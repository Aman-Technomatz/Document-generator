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


  def new
    @document = Document.new
    @document.build_user
  end

  def edit
  end

  def create
    if params[:document][:user_option] == "new"
      @document = Document.new(document_params)
    else
      user_id = params[:document][:user_id].presence
      @document = Document.new(document_params.except(:user_attributes).merge(user_id: user_id))
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

  def destroy
    @document.destroy!

    respond_to do |format|
      format.html { redirect_to documents_path, status: :see_other, notice: "Document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_document
  @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :document_type, :end_position, :start_position, :end_date, :start_date, :user_id, :ctc, :current_salary, :new_salary, :experience_years, :last_working_day, :reason, :gratitude, :effective_date, user_attributes: [:name, :email, :position])
  end

end
