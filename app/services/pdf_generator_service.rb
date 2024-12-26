class PdfGeneratorService
  def initialize(document)
    @document = document
    @payslip = @document.payslip
  end

  def generate_pdf
    pdf = Prawn::Document.new(page_size: 'A4', margin: [50, 20, 20, 20])

    font_path_regular = Rails.root.join('app', 'assets', 'fonts', 'DejaVuSans.ttf')
    font_path_bold = Rails.root.join('app', 'assets', 'fonts', 'DejaVuSans-Bold.ttf')

    pdf.font_families.update('DejaVu' => { normal: font_path_regular, bold: font_path_bold })

    pdf.font 'Helvetica'
    # Add fonts and colors
    pdf.fill_color '000000'

    add_header(pdf)

    pdf.move_down 20

    # Employee Summary Section
    add_employee_summary(pdf)

    pdf.move_down 20

    # Earnings and Deductions Table
    add_earnings_and_deductions(pdf)

    pdf.move_down 20

    # Total Net Pay
    add_total_net_pay(pdf)

    pdf.move_down 10

    # Amount in Words
    add_amount_in_words(pdf)

    pdf.move_down 20

    # Footer
    add_footer(pdf)

    pdf.render
  end

  private

  def add_header(pdf)
    logo_width = 60
    logo_height = 60

    # Add current date and time below the header
    # pdf.bounding_box([-470, pdf.cursor+40], width: pdf.bounds.width) do
    #   current_time = Time.now.strftime('%d/%m/%Y, %H:%M')  # Format the current date and time
    #   pdf.text current_time, size: 10, style: :italic, align: :right  # Align to the right
    # end

    # Positioning the logo slightly lower
    if @payslip.logo.attached?
      pdf.image StringIO.new(@payslip.logo.download), width: logo_width, height: logo_height, at: [0, pdf.cursor + 15]
    end

    # Organization details next to the logo
    pdf.bounding_box([logo_width + 10, pdf.cursor], width: pdf.bounds.width - (logo_width + 10)) do
      pdf.text @document.organization_name, size: 12, style: :bold
      pdf.text "#{@document.company_address}, #{@document.city}, #{@document.pincode}, #{@document.country}", size: 10
    end

    # "Payslip For the Month" on the far right
    pdf.bounding_box([pdf.bounds.width - 150, pdf.cursor + 30], width: 150) do
      pdf.text "Payslip For the Month", size: 8, align: :right
      pdf.text @payslip.pay_slip_for_month&.strftime('%B %Y'), size: 8, align: :right
    end

    pdf.move_down 10
  end

  def add_employee_summary(pdf)
    # Change the stroke color to light gray
    pdf.stroke_color "DDDDDD"  # Set the stroke color to light gray

    # Change the line width to make it thinner
    pdf.line_width = 0.8  # Set the line width to a thinner value (default is 1)

    # Draw the horizontal rule
    pdf.stroke_horizontal_rule

    pdf.move_down 10
    pdf.indent(8) do
      pdf.text "EMPLOYEE SUMMARY", size: 10, style: :bold
    end

    pdf.move_down 6

    # Left-side content
    left_data = [
      ["Employee Name", ":  #{@document.user.name.titleize}"],
      ["Employee ID", ":  #{@document.employee_id}"],
      ["Pay Period", ":  #{@payslip.pay_period.strftime("%B %Y")}"],
      ["Pay Date", ":  #{@payslip.pay_date}"]
    ]

    left_column_width = pdf.bounds.width * 0.65
    right_column_width = pdf.bounds.width - left_column_width

    pdf.bounding_box([0, pdf.cursor], width: left_column_width) do
      pdf.table(left_data, cell_style: { borders: [], padding: [5, 10], size: 10}, column_widths: [120, left_column_width - 120]) do |t|
        t.columns(1).style(font_style: :bold)
      end
    end

    # Right-side box
    pdf.bounding_box([left_column_width, pdf.cursor + 90], width: right_column_width, height: 80) do
      # Set the background for the whole box
      pdf.fill_color "FFFFFF"  # Light gray background color
      pdf.fill_rectangle [pdf.bounds.left, pdf.bounds.top], pdf.bounds.width, pdf.bounds.height
      pdf.stroke_color "AAAAAA"  # Light gray border
      pdf.line_width = 0.2
      pdf.stroke_bounds
      pdf.fill_color "000000"  # Reset font color to black

      pdf.indent(10) do
        pdf.move_down 10

        # Background for the amount text (half box width)
        pdf.fill_color "E0F7E0"  # Very light green color

        pdf.fill_rectangle [pdf.bounds.left - 8.5, pdf.cursor + 10], pdf.bounds.width + 7.5, 30  # Increased width by 40
        pdf.fill_rectangle [pdf.bounds.left - 8.5, pdf.cursor - 10], pdf.bounds.width + 7.5, 20  # Increased width by 40


        pdf.fill_color "000000"  # Reset font color to black
        pdf.move_down 10
        # Position for the ₹ symbol
        pdf.font('DejaVu')  # Switch to DejaVu for ₹ symbol
        rupee_text = "₹"
        rupee_width = pdf.width_of(rupee_text)  # Get the width of the ₹ symbol

        # Position the ₹ symbol
        pdf.draw_text rupee_text, at: [pdf.bounds.left , pdf.cursor + 5]

        # Now position the amount next to ₹ (using Helvetica for the amount)
        pdf.font('Helvetica', style: :bold, align: :left)
        amount_text = "#{@payslip.total_net_payable}"
        pdf.draw_text amount_text, at: [pdf.bounds.left + rupee_width, pdf.cursor + 5]
        pdf.move_down 0

        # Text for "Employee Net Pay"
        pdf.text "Employee Net Pay", size: 7, align: :left
        pdf.move_down 20

        # Remaining text
        pdf.text "Paid Days           :  #{@payslip.paid_days}", size: 10, align: :left
        pdf.move_down 5
        pdf.text "LOP Days           :  #{@payslip.loss_of_pay_days}", size: 10, align: :left
      end
    end

    pdf.move_down 30

    # Change the stroke color to light gray
    pdf.stroke_color "DDDDDD"  # Set the stroke color to light gray

    # Change the line width to make it thinner
    pdf.line_width = 0.8  # Set the line width to a thinner value (default is 1)

    # Draw the horizontal rule
    pdf.stroke_horizontal_rule
  end

  def add_earnings_and_deductions(pdf)
    # Table data
    table_data = [
      ["EARNINGS", "AMOUNT", "DEDUCTIONS", "AMOUNT"],  # Header row
      ["Basic Salary", format_amount(pdf, @payslip.basic_salary), "Income Tax",  "₹#{@payslip.income_tax}"],
      ["House Rent Allowance", "₹#{@payslip.house_rent_allowance}", "Provident Fund", "₹#{@payslip.provident_fund}"],
      ["Other Allowance", "₹#{@payslip.other_allowance}"],
      ["Gross Earnings", "₹#{@payslip.gross_earnings}", "Total Deductions", "₹#{@payslip.total_deductions}"]
    ]

    # Create table
    table = pdf.make_table(
      table_data,
      header: true,
      column_widths: [185, 90, 100, 175],  # Adjust column widths
      cell_style: {
        borders: [],             # Remove all internal borders
        padding: [5, 10],        # Adjust padding
        size: 10,                # Font size
        align: :center           # Default alignment for text in cells
      },
      row_colors: ["F9F9F9", "FFFFFF"]  # Alternating row colors
    )

    # Apply custom alignment and styling for specific cells
    table.cells.each do |cell|
      cell.size = 8
      if cell.row == 0  # Header row
        cell.font_style = :bold
        cell.background_color = "F2F2F2"  # Light gray background for header

        # Adjust alignment for header columns
        if cell.column == 0 || cell.column == 2  # EARNINGS column (extreme left)
          cell.align = :left
        elsif cell.column == 1 || cell.column == 3  # AMOUNT column (extreme right)
          cell.align = :right
        end
      else
        # Adjust alignment for body cells
        if cell.column == 0  || cell.column == 2 # EARNINGS align to left
          cell.align = :left
        elsif cell.column == 1 || cell.column == 3   # AMOUNT and DEDUCTIONS align center
          cell.align = :right
        end

        # Highlight "Gross Earnings" and "Total Deductions"
        if cell.row == 4  # Specific row
          cell.font_style = :bold
          cell.background_color = "FFFFCC"  # Light yellow background
        end
      end
    end

    # Render the table with an outer border only
    pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width) do
      pdf.stroke_color "000000"  # Set stroke color for the outer border
      pdf.line_width = 0.5       # Set line width for the border
      pdf.stroke_bounds          # Draw the outer border
      table.draw                 # Draw the table inside the bounding box
    end

    # Change the stroke color to light gray
    pdf.stroke_color "DDDDDD"  # Set the stroke color to light gray

    # Change the line width to make it thinner
    pdf.line_width = 0.8  # Set the line width to a thinner value (default is 1)

    # Draw the horizontal rule
    pdf.stroke_horizontal_rule

    pdf.move_down 20
  end

  # Helper method to format amounts with ₹ symbol
  def format_amount(pdf, amount)
    pdf.font('DejaVu')  # Switch to DejaVu for ₹ symbol
    "₹#{amount}"
  end

  def add_total_net_pay(pdf)
    # Define the height of the box and the position where it will be placed
    box_height = 40

    # Create a bounding box to contain the content (at current cursor position)
    pdf.bounding_box([pdf.bounds.left, pdf.cursor], width: pdf.bounds.width, height: box_height) do
      # Draw the border around the bounding box
      pdf.stroke_color "AAAAAA"  # Light gray color for the border
      pdf.line_width = 0.5  # Default is 1; reduce to make it lighter
      pdf.stroke_bounds
      pdf.move_down 10

      # Draw a light green background for the right half of the box (cover full box height)
      pdf.fill_color "E0F7E0"  # Light green color
      pdf.fill_rectangle [pdf.bounds.left + pdf.bounds.width / 2 + 125, pdf.cursor+11], pdf.bounds.width / 2- 125, box_height  # Cover the full height of the box
      pdf.fill_color "000000"  # Reset font color to black

      # Adjust the left-side content position with an indent
      pdf.indent(20) do # Moves left-side content 20 points to the right
        pdf.text "TOTAL NET PAYABLE", size: 8, style: :bold, align: :left  # Left-align the title
        pdf.move_down 3
        pdf.text "Gross Earnings – Total Deductions", size: 8, align: :left  # Left-align the subtitle
      end

      # Switch to DejaVu for ₹ symbol
      pdf.font('DejaVu')  # Use DejaVu for ₹ symbol
      rupee_text = "₹"
      rupee_width = pdf.width_of(rupee_text)  # Get the width of the ₹ symbol

      # Adjust the vertical position to move the ₹ symbol slightly above
      rupee_y_position = pdf.cursor + 10  # Move up 10 points to raise ₹ symbol
      pdf.draw_text rupee_text, at: [pdf.cursor + 460, rupee_y_position]

      # Now position the amount next to ₹ (using Helvetica for the amount)
      net_pay_text = "#{@payslip.total_net_payable}"
      pdf.font('Helvetica', style: :bold)
      text_width = pdf.width_of(net_pay_text, size: 14, style: :bold)

      # Calculate the X-position to align the amount correctly
      right_content_x = pdf.bounds.right - text_width - 30

      # Position the amount correctly aligned with ₹
      pdf.draw_text net_pay_text, size: 14, style: :bold, at: [right_content_x+10, pdf.cursor+10]
    end
  end

  def add_amount_in_words(pdf)
    # Amount in words section
    pdf.move_down 20

    amount_text = "Amount In Words: "
    amount_width = pdf.width_of(amount_text, size: 10)

    # amount_width = pdf.width_of(amount_text)  # Get the width of "Amount In Words:"

    # Calculate the starting X position to center everything
    amount_text_x = (pdf.bounds.width - amount_width) / 2 - 7

    # Draw "Amount In Words"
    pdf.font('Helvetica', style: :italic, size: 8)
    pdf.draw_text amount_text, at: [amount_text_x-220, pdf.cursor]

    # Now draw the ₹ symbol and the amount in words
    pdf.font('DejaVu', size: 10)  # Switch to DejaVu for ₹ symbol
    rupee_text = "₹"
    rupee_width = pdf.width_of(rupee_text)  # Get the width of the ₹ symbol

    # Position the ₹ symbol after "Amount In Words"
    # pdf.draw_text rupee_text, at: [amount_text_x + amount_width-240, pdf.cursor]

    # Now position the amount in words text
    amount = @payslip.total_net_payable
    amount_in_words = "#{number_to_indian_words(amount.to_i)} Only"
    amount_in_words_width = pdf.width_of(amount_in_words, size: 10)  # Get the width of the amount text

    # Draw the amount in words after the ₹ symbol
    pdf.font('Helvetica', style: :italic, size: 10)
    pdf.draw_text amount_in_words, at: [amount_text_x + amount_width + rupee_width-240, pdf.cursor]

    pdf.move_down 20  # Move down after rendering the text

    # Change the stroke color to light gray
    pdf.stroke_color "DDDDDD"  # Set the stroke color to light gray

    # Change the line width to make it thinner
    pdf.line_width = 0.8  # Set the line width to a thinner value (default is 1)

    # Draw the horizontal rule
    pdf.stroke_horizontal_rule
  end

  def add_footer(pdf)
    pdf.fill_color "888888" # Slightly darker gray
    pdf.text "*This is a system-generated payslip and does not require a signature.", size: 10, style: :italic, align: :left
    pdf.fill_color "000000" # Reset to black for subsequent text
  end

  def number_to_indian_words(number)
    words = {
      0 => "Zero", 1 => "One", 2 => "Two", 3 => "Three", 4 => "Four", 5 => "Five",
      6 => "Six", 7 => "Seven", 8 => "Eight", 9 => "Nine", 10 => "Ten",
      11 => "Eleven", 12 => "Twelve", 13 => "Thirteen", 14 => "Fourteen",
      15 => "Fifteen", 16 => "Sixteen", 17 => "Seventeen", 18 => "Eighteen",
      19 => "Nineteen", 20 => "Twenty", 30 => "Thirty", 40 => "Forty",
      50 => "Fifty", 60 => "Sixty", 70 => "Seventy", 80 => "Eighty", 90 => "Ninety"
    }

    return "Zero" if number == 0

    parts = []

    # Break the number into components
    crores = number / 10000000
    parts << "#{convert_to_words(crores, words)} Crore" if crores > 0
    number %= 10000000

    lakhs = number / 100000
    parts << "#{convert_to_words(lakhs, words)} Lakh" if lakhs > 0
    number %= 100000

    thousands = number / 1000
    parts << "#{convert_to_words(thousands, words)} Thousand" if thousands > 0
    number %= 1000

    hundreds = number / 100
    parts << "#{convert_to_words(hundreds, words)} Hundred" if hundreds > 0
    number %= 100

    parts << "and" if parts.any? && number > 0  # Add "and" before the last part

    parts << convert_to_words(number, words) if number > 0

    parts.reject(&:nil?).reject(&:empty?).join(" ").strip
  end

  def convert_to_words(number, words)
    return "" if number == 0
    if words.key?(number)
      words[number]
    else
      tens = number / 10 * 10
      units = number % 10
      [words[tens], words[units]].compact.join(" ").strip
    end
  end

  def format_amount(pdf, amount)
    pdf.font('DejaVu')  # Switch to DejaVu for ₹ symbol
    "₹#{amount}"
  end
end
