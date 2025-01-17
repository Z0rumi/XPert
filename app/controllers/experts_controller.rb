class ExpertsController < ApplicationController
  before_action :set_expert, only: %i[ show edit update destroy ]
  before_action :set_dropdown_options, only: %i[ new create edit update ]
  before_action :check_expert, except: %i[ new create edit update show ]
  before_action :check_intern, only: %i[ new create edit update destroy ]
  before_action :check_initiated, only: %i[ new create ]
  before_action :check_diffrent_expert, only: %i[ show show_modal edit ]
  before_action :authenticate_user!

  # GET /experts or /experts.json
  def index
    @experts = Expert.all
    @categories = Category.all
    @course_modules = CourseModule.all
    @q = Expert.ransack(params[:q])
    @experts = @q.result(distinct: true)
  end

  # GET /experts/1 or /experts/1.json
  def show
  end

  def show_modal
  end

  # GET /experts/new
  def new
    @expert = Expert.new
    @categories = Category.all
    @course_modules = CourseModule.all
  end

  # GET /experts/1/edit
  def edit
    @categories = Category.all
    @course_modules = CourseModule.all
  end

  # POST /experts or /experts.json
  def create
    @expert = Expert.new(expert_params)
    @categories = Category.all
    @course_modules = CourseModule.all

    respond_to do |format|
      if @expert.save
        if current_user.expert?
          current_user.update(expert_id: @expert.id, initiated: true)
        end
        format.html { redirect_to @expert, notice: "Expert*in wurde erfolgreich erstellt." }
        format.json { render :show, status: :created, location: @expert }
      else
        @categories = Category.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /experts/1 or /experts/1.json
  def update
    @categories = Category.all
    @course_modules = CourseModule.all
    respond_to do |format|
      if @expert.update(expert_params)
        format.html { redirect_to @expert, notice: "Expert*in wurde erfolgreich aktualisiert." }
        format.json { render :show, status: :ok, location: @expert }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experts/1 or /experts/1.json
  def destroy
    @expert.destroy!

    respond_to do |format|
      format.html { redirect_to experts_path, status: :see_other, notice: "Expert*in wurde erfolgreich gelöscht." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expert
      @expert = Expert.find(params[:id])
    end

    # Set dropdown options for forms.
    def set_dropdown_options
      @salutations = [ "Herr", "Frau", "divers", "Keine Angabe" ]
      @teaching_languages = [ "Deutsch", "Englisch", "Chinesisch" ]
      @communication_languages = [ "Deutsch", "Englisch", "Chinesisch" ]
      @travel_willingnesses = [ "online", "Deutschland", "China" ]
    end

    # Only allow a list of trusted parameters through.
    def expert_params
      params.require(:expert).permit(:cv, :salutation, :first_name, :last_name, :nationality, :phone_number, :email, :location, :hourly_rate, :daily_rate, :remark_travel_willingness, :availability, :china_experience, :institution, :cooperation_opportunity, :remarks, :title, :extra_category, :institution_association, travel_willingnesses: [], communication_languages: [], category_ids: [], course_module_ids: [], teaching_languages: []).tap do |params|
        params[:hourly_rate] = params[:hourly_rate].to_f * 100.00
        params[:daily_rate] = params[:daily_rate].to_f * 100.00
      end
    end

    # Checks if current_user has role expert, to restrict access
    def check_expert
      return unless current_user

      @user = current_user
      if @user.expert?
        if @user.initiated
          redirect_to expert_profile_path(current_user.expert_id), notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
        else
          redirect_to new_expert_path, notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
        end
      end
    end

    # Checks if current_user has role intern, to restrict modifying rights
    def check_intern
      return unless current_user

      @user = current_user
      if @user.intern?
        redirect_to experts_path, notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
      end
    end

    # Checks if user is initiated, so that a user can only create one expert profile
    def check_initiated
      return unless current_user

      @user = current_user
      if @user.expert? && @user.initiated
        redirect_to expert_profile_path(@user.expert_id), notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
      end
    end

    # Checks that expert only has access to his own profile
    def check_diffrent_expert
      return unless current_user

      @expert = Expert.find(params[:id])
      @user = current_user

      if @user.expert? && @user.expert_id != @expert.id
        redirect_to expert_profile_path(@user.expert_id), notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
      end
    end
end
