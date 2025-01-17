# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [ :update ]
  before_action :authenticate_user!, except: [ :new, :create ]
  before_action :check_expert, except: %i[ edit edit_password edit_email update destroy ]
  before_action :check_intern, only: %i[ one_time_link_form one_time_link new create destroy ]
  before_action :check_staff, only: %i[ new create destroy ]


  # GET /resource/sign_up
  def new
    @one_time_link = OneTimeLink.find_by(token: params[:token])

    # link is valid?
    if @one_time_link && !@one_time_link.used && @one_time_link.expires_at > Time.current
      super
    else
      flash[:alert] = "Der Link ist ungültig oder wurde bereits verwendet."
      redirect_to root_path
    end
  end

  # render otl form
  def one_time_link_form
  end

  # create otl
  def one_time_link
    token = SecureRandom.hex(10)
    email = params[:email]

    one_time_link = OneTimeLink.new(token: token, expires_at: 1.day.from_now, used: false)

    if one_time_link.save
      registration_link = new_user_registration_url(token: token)
      UserMailer.send_otl(email, registration_link).deliver_later
      flash.now[:notice] = "Einmallink wurde erfolgreich versendet."

      render :one_time_link_form
    else
      flash.now[:alert] = "Fehler beim Erstellen des Einmallinks."
      render :one_time_link_form, status: :unprocessable_entity
    end
  end

  # POST /resource
  # WICHTIG: Hier wurde statt super die volle create methode aus dem gem kopiert, da der redirect bei einem Fehler standardmäßig nicht den Token weiterleitet.
  def create
    @one_time_link = OneTimeLink.find_by(token: params[:user][:token])

    # Link ist gültig?
    if @one_time_link && !@one_time_link.used && @one_time_link.expires_at > Time.current
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?

      if resource.persisted?
        @one_time_link.update(used: true)
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length

        custom_errors = resource.errors.messages.map do |attribute, messages|
          messages.compact.join(", ") if messages.present? # Ensure messages are present and not nil
        end

        flash[:alert] = custom_errors.to_sentence
        redirect_to new_user_registration_path(token: params[:user][:token]) and return
      end
    else
      flash[:notice] = "Der Link ist ungültig oder wurde bereits verwendet."
      redirect_to root_path
    end
  end



  # GET /resource/edit
  # def edit
  #   super
  # end

  # GET /resource/edit_password
  def edit_password
    self.resource = current_user
  end

  # GET /resource/edit_email
  def edit_email
    self.resource = current_user
  end

  # PUT /resource
  # WICHTIG! Hier wurde die Devise Methode eingefügt, um das redirect bei Fehlern korrekt zu verarbeiten.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in(resource, scope: resource_name) if sign_in_after_change_password?
      flash[:notice] = "Ihr Konto wurde erfolgreich aktualisiert."
      respond_with resource, location: after_update_path_for(resource)
    else
      form_type = params[:form_type]
      case form_type
      when "password"
        flash[:notice] = resource.errors.full_messages.to_sentence
        render :edit_password
      when "email"
        flash[:notice] = resource.errors.full_messages.to_sentence
        render :edit_email
      else
        flash[:notice] = resource.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    @user = current_user
    if @user.expert?
      if @user.initiated
        expert_profile_path(@user.expert_id)
      else
        @expert = Expert.find_by(email: @user.email)
        if @expert
          @user.update(expert_id: @expert.id, initiated: true)
          expert_profile_path(@user.expert_id)
        else
          new_expert_path
        end
      end
    else
      root_path
    end
  end

  # The path used after update.
  def after_update_path_for(resource)
    @user = current_user
    if @user.expert?
      expert_profile_path(@user.expert_id)
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def configure_account_update_params
    if current_user.staff?
      devise_parameter_sanitizer.permit(:account_update, keys: [ :password, :password_confirmation, :current_password, :form_type ])
    else
      devise_parameter_sanitizer.permit(:account_update, keys: [ :email, :password, :password_confirmation, :current_password, :form_type ])
    end
  end

  # Checks if current_user has role expert, to restrict access
  def check_expert
    return unless current_user

    @user = current_user
    if @user.expert?
      if @user.initiated
        redirect_to expert_profile_path(current_user.expert_id), notice: "Sie haben nicht die benötigten Berechtigungen, um diese Aktion auszuführen."
      else
        redirect_to new_expert_path, notice: "Sie haben nicht die benötigten Berechtigungen, um diese Aktion auszuführen."
      end
    end
  end

  # Checks if current_user has role intern, to restrict modifying rights
  def check_intern
    return unless current_user

    @user = current_user
    if @user.intern?
      redirect_to root_path, notice: "Sie haben nicht die benötigten Berechtigungen, um diese Aktion auszuführen."
    end
  end

  def check_staff
    return unless current_user

    @user = current_user
    if @user.staff?
      redirect_to root_path, notice: "Sie haben nicht die benötigten Berechtigungen, um diese Aktion auszuführen."
    end
  end
end
