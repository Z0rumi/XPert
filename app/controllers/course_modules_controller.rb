class CourseModulesController < ApplicationController
  before_action :set_course_module, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :check_expert, except: %i[ show ]
  before_action :check_intern, only: %i[ new create edit update destroy ]

  # GET /course_modules or /course_modules.json
  def index
    @course_modules = CourseModule.all
  end

  # GET /course_modules/1 or /course_modules/1.json
  def show
  end

  # GET /course_modules/new
  def new
    @course_module = CourseModule.new
  end

  # GET /course_modules/1/edit
  def edit
  end

  # POST /course_modules or /course_modules.json
  def create
    @course_module = CourseModule.new(course_module_params)

    respond_to do |format|
      if @course_module.save
        format.html { redirect_to course_modules_path, notice: "Kursmodul wurde erfolgreich erstellt." }
        format.json { render json: { message: "Kursmodul wurde erfolgreich erstellt.", redirect_to: course_modules_path }, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_modules/1 or /course_modules/1.json
  def update
    respond_to do |format|
      if @course_module.update(course_module_params)
        format.html { redirect_to course_modules_path, notice: "Kursmodul wurde erfolgreich aktualisiert." }
        format.json { render json: { message: "Kursmodul wurde erfolgreich aktualisiert.", redirect_to: course_modules_path }, status: :updated }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_modules/1 or /course_modules/1.json
  def destroy
    @course_module.destroy!

    respond_to do |format|
      format.html { redirect_to course_modules_path, status: :see_other, notice: "Kursmodul wurde erfolgreich gelöscht." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_module
      @course_module = CourseModule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_module_params
      params.require(:course_module).permit(:name, :description)
    end

    # Checks if current_user has role expert, to restrict access
    def check_expert
      return unless current_user

      @user = current_user

      if @user.expert?
        if @user.initiated == false
          redirect_to new_expert_path, notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
        else
          redirect_to expert_profile_path(current_user.expert_id), notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
        end
      end
    end

    # Checks if current_user has role intern, to restrict modifying rights
    def check_intern
      return unless current_user

      @user = current_user
      if @user.intern?
        redirect_to course_modules_path, notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
      end
    end
end
