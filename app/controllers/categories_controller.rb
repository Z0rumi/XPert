class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :check_expert
  before_action :check_intern, only: %i[ new create edit update destroy ]

  # GET /categories or /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: "Thema/Fachgebiet wurde erfolgreich erstellt." }
        format.json { render json: { message: "Thema/Fachgebiet wurde erfolgreich erstellt.", redirect_to: categories_path }, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_path, notice: "Thema/Fachgebiet wurde erfolgreich aktualisiert." }
        format.json { render json: { message: "Thema/Fachgebiet wurde erfolgreich aktualisiert.", redirect_to: categories_path }, status: :updated }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy!

    respond_to do |format|
      format.html { redirect_to categories_path, status: :see_other, notice: "Thema/Fachgebiet wurde erfolgreich gelöscht." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name)
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
        redirect_to categories_path, notice: "Sie haben nicht die benötigten Berechtigungen, um auf diese Seite zuzugreifen."
      end
    end
end
