class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy ]

  def index
    @documents = Document.search_by_query(params[:query])
    if @documents.present?
      @pagy, @documents = pagy(@documents)
    else
      flash[:alert] = "No result found."
    end
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Document_#{@document.document_type}"
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
      if @document.user_id.blank?
        flash[:alert] = "Please select an existing user or create user."
        return render :new, status: :unprocessable_entity
      end
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
    params.require(:document).permit(
      :organization_name,
      :document_type,
      :start_date,
      :start_position,
      :ctc,
      :work_timings,
      :probation_period,
      :service_agreement,
      :annual_leave,
      :notice_period,
      :experience_years,
      :current_salary,
      :end_position,
      :end_date,
      :gratitude,
      :employee_id,
      :user_id,
      user_attributes: [:id, :name, :email, :position]
    )
  end

end
