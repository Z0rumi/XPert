class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :set_dropdown_options, only: %i[ index new create edit update ]
  before_action :check_expert
  before_action :check_intern, only: %i[ new create edit update destroy ]
  before_action :authenticate_user!


  # GET /projects or /projects.json
  def index
    @projects = Project.all
    @categories = Category.all
    @course_modules = CourseModule.all
    @q = Project.ransack(params[:q])
    @projects = @q.result(distinct: true)
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @experts = Expert.all
  end

  # GET /projects/1/edit
  def edit
    @experts = Expert.all
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params.except(:documents))
    @experts = Expert.all

    respond_to do |format|
      if @project.save
        attach_documents(@project, project_params[:documents])
        format.html { redirect_to @project, notice: "Projekt wurde erfolgreich erstellt." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params.except(:documents))
        attach_documents(@project, project_params[:documents])
        format.html { redirect_to @project, notice: "Projekt wurde erfolgreich aktualisiert." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_path, status: :see_other, notice: "Projekt wurde erfolgreich gelöscht." }
      format.json { head :no_content }
    end
  end

  # PATCH documents in project
  def add_documents
    @project = Project.find(params[:id])
    if params[:project] && params[:project][:documents]
      params[:project][:documents].each do |doc|
        @project.documents.attach(doc)
      end
    end
    redirect_to project_path(@project), notice: "Dokument(e) hochgeladen."
  end

  # DELETE document from project
  def remove_document
    @project = Project.find(params[:id])
    attachment = @project.documents.find(params[:document_id])
    attachment.purge
    redirect_to project_path(@project), notice: "Dokument wurde gelöscht."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Set dropdown options for forms.
    def set_dropdown_options
      @project_types = [ "Delegationsbesuch", "Dozentenfortbildung", "fachliche Weiterbildung", "Summer School" ]
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:project_name, :main_topics, :start_date, :end_date, :project_type, :client, :location, :city, expert_ids: [], documents: [])
    end

    # method used to attach documents to the project returns if no documents were passed in params
    def attach_documents(project, documents)
      return if documents.blank?

      documents.each do |doc|
        project.documents.attach(doc)
      end
    end

    # Checks if current_user has role expert, to restrict access.
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

    # Checks if current_user has role intern, to restrict modifiyng rights.
    def check_intern
      return unless current_user

      @user = current_user
      if @user.intern?
        redirect_to projects_path, notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
      end
    end
end
