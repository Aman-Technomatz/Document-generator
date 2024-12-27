class DocumentsController < ApplicationController
  require 'prawn/table'

  before_action :set_document, only: %i[ show edit update destroy generate_pdf ]

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

  def generate_pdf
    @document = Document.find(params[:id])

    if @document.document_type == 'payslip'
      pdf_content = PdfGeneratorService.new(@document).generate_pdf

      send_data pdf_content,
                filename: "Payslip_#{@document.id}.pdf",
                type: 'application/pdf',
                disposition: 'inline'
    else
      respond_to do |format|
        format.html
        format.pdf do
          html = render_to_string(template: "documents/generate_pdf")

          pdf = PDFKit.new(html)

          send_data pdf.to_pdf,
                    filename: "Document_#{@document.document_type}.pdf",
                    type: 'application/pdf',
                    disposition: 'inline'
        end
      end
    end
  end

  def new
    @document = Document.new
    @document.build_user
    @document.build_payslip
  end

  def edit
  end

  def create
    pay_slip_for_end_month = params[:document][:payslip_attributes][:pay_slip_for_end_month]
    params[:document][:payslip_attributes].delete(:pay_slip_for_end_month)

    if params[:document][:user_option] == "new"
      # New user flow
      @document = Document.new(document_params)
      if pay_slip_for_end_month.present?
        create_bulk_payslips(@document, pay_slip_for_end_month)
        redirect_to documents_path, notice: "Documents were successfully created."
        return # Stop further execution
      else
        # Single payslip creation logic
        @payslip = @document.payslip
      end
    else
      # Existing user flow
      user_id = params[:document][:user_id].presence
      @document = Document.new(document_params.except(:user_attributes).merge(user_id: user_id))

      if @document.user_id.blank?
        flash[:alert] = "Please select an existing user or create a user."
        render :new, status: :unprocessable_entity
        return # Stop further execution
      end

      if pay_slip_for_end_month.present?
        create_bulk_payslips(@document, pay_slip_for_end_month)
        redirect_to documents_path, notice: "Documents were successfully created."
        return # Stop further execution
      else
        # Single payslip creation logic
        @payslip = @document.payslip
      end
    end

    # Single document save logic
    if @document.save
      redirect_to documents_path, notice: "Document was successfully created."
    else
      render :new, status: :unprocessable_entity
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

  def create_bulk_payslips(document, end_date)
    start_month = document.payslip.pay_slip_for_month.beginning_of_month
    end_month = end_date.to_date.end_of_month
    base_pay_date = document.payslip.pay_date

    if start_month > end_month
      flash[:alert] = "Start month cannot be later than end month."
      return render :new, status: :unprocessable_entity
    end

    # Bulk create payslips for the range
    current_month = start_month
    created_documents = []
    while current_month <= end_month
      days_in_month = current_month.end_of_month.day
      paid_days = days_in_month

      # Adjust the pay_date to match the provided day in each month
      pay_date = adjust_pay_date(current_month, base_pay_date)

      # Clone the base document with all its attributes
      new_document = document.dup
      new_payslip = document.payslip.dup

      # Update the necessary fields on the duplicated payslip
      new_payslip.pay_slip_for_month = current_month
      new_payslip.paid_days = paid_days
      new_payslip.pay_date = pay_date

      new_document.payslip = new_payslip

      if new_document.save
        created_documents << new_document
      else
        flash[:alert] = "Error saving payslip for #{current_month.strftime('%B %Y')}: #{new_document.errors.full_messages.to_sentence}"
        return render :new, status: :unprocessable_entity
      end
      # Move to the next month
      current_month = current_month.next_month.beginning_of_month
    end
  end

  def adjust_pay_date(current_month, base_pay_date)
    # Use the day of the provided pay_date, and match it with the current month
    day = base_pay_date.day
    year = current_month.year
    month = current_month.next_month.month

    # Ensure the day is valid for the month
    adjusted_date = Date.new(year, month, [day, current_month.end_of_month.day].min)

    # Optional: Adjust for weekends (move to previous Friday if it falls on Sat/Sun)
    while adjusted_date.saturday? || adjusted_date.sunday?
      adjusted_date -= 1.day
    end

    adjusted_date
  end


  def set_document
  @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit( :organization_name, :document_type, :start_date, :start_position, :ctc, :work_timings, :probation_period, :service_agreement, :annual_leave, :notice_period, :experience_years, :current_salary, :end_position, :end_date, :gratitude, :employee_id, :user_id, :hr_name, :company_address, :city, :pincode, :country, payslip_attributes: [ :paid_days, :loss_of_pay_days, :pay_date, :basic_salary, :income_tax, :house_rent_allowance, :provident_fund, :gross_earnings, :total_deductions, :total_net_payable, :pay_slip_for_month, :logo, :other_allowance], user_attributes: [:id, :name, :email])
  end

end
