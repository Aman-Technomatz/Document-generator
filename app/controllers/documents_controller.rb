class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy ]

  def index
    @documents = Document.all
  end

  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Document_#{@document.id}"
      end
    end
  end


  # GET /documents/new
  def new
    @document = Document.new
    @document.build_user # Initialize user fields for nested form
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents or /documents.json
  def create
    if params[:user_option] == 'new'
      # If creating a new user, use nested attributes
      @document = Document.new(document_params.merge(user_id: nil))
    else
      # Otherwise, ignore nested user attributes
      @document = Document.new(document_params.except(:user_attributes))
    end

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: "Document was successfully created." }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: "Document was successfully updated." }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy!

    respond_to do |format|
      format.html { redirect_to documents_path, status: :see_other, notice: "Document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:title, :document_type, :end_position, :start_position, :end_date, :start_date, :employee_id, :user_id, user_attributes: [:name, :email, :position])
    end
end
