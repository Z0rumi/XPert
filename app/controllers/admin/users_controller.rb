class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dropdown_options, only: %i[ new create edit update ]
  before_action :check_admin

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "Benutzer*in wurde erfolgreich erstellt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      # Don't require password if none is provided
      if @user.update(params.require(:user).permit(:email, :role))
        redirect_to admin_users_path, notice: "Benutzer*in wurde erfolgreich aktualisiert."
      else
        flash.now[:alert] = @user.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    else
      # Require password confirmation if password is provided
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "Benutzer*in wurde erfolgreich aktualisiert."
      else
        flash.now[:alert] = @user.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, notice: "Benutzer*in wurde erfolgreich gelöscht."
    else
      redirect_to admin_users_path, alert: @user.errors.full_messages.join(", ")
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  # Set dropdown options for forms.
  def set_dropdown_options
    @roles = User.roles.keys
  end

  def check_admin
    @user = current_user
    if !@user.admin?
      if @user.expert?
        if @user.initiated
          redirect_to expert_profile_path(current_user.expert_id), notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
        else
          redirect_to new_expert_path, notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
        end
      else
         redirect_to root_path, notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
      end
    end
  end
end
