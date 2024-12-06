document.addEventListener('DOMContentLoaded', function () {
  function toggleDocumentFields() {
    const docType = document.getElementById('document_type').value;

    document.querySelectorAll('.conditional-fields').forEach(function (field) {
      field.style.display = 'none';
      field.querySelectorAll('input, select, textarea').forEach(function (input) {
        input.removeAttribute('required');
      });
    });

    document.getElementById('for_end_date').style.display = 'none';

    const endDateField = document.getElementById('for_end_date');
    endDateField.style.display = 'none';
    endDateField.querySelector('input').removeAttribute('required');

    const startDateField = document.getElementById('for_start_date');
    startDateField.style.display = 'none';
    startDateField.querySelector('input').removeAttribute('required');

    const ctcField = document.getElementById('for_ctc');
    ctcField.style.display = 'none';
    ctcField.querySelector('input').removeAttribute('required');

    const startPositionField = document.getElementById('for_start_position');
    startPositionField.style.display = 'none';
    startPositionField.querySelector('input').removeAttribute('required');

    const endPositionField = document.getElementById('for_end_position');
    endPositionField.style.display = 'none';
    endPositionField.querySelector('input').removeAttribute('required');

    const payslipFields = document.getElementById('payslip-fields');
    const payslip = document.getElementById('payslip');
    payslipFields.style.display = 'none';
    payslip.style.display = 'none';



    document.querySelectorAll('#common_fields input').forEach(function (input) {
      input.setAttribute('required', 'true');
    });

    switch (docType) {
      case 'appointment_letter':
        document.getElementById('appointment_letter_fields').style.display = 'block';
        startDateField.style.display = 'block';
        startDateField.querySelector('input').setAttribute('required', 'true');
        ctcField.style.display = 'block';
        ctcField.querySelector('input').setAttribute('required', 'true');
        startPositionField.style.display = 'block';
        startPositionField.querySelector('input').setAttribute('required', 'true');
        document.querySelectorAll('#appointment_letter_fields input').forEach(function (input) {
          input.setAttribute('required', 'true');
        });
        break;

      case 'experience_letter':
        startDateField.style.display = 'block';
        startDateField.querySelector('input').setAttribute('required', 'true');
        endDateField.style.display = 'block';
        endDateField.querySelector('input').setAttribute('required', 'true');
        endPositionField.style.display = 'block';
        endPositionField.querySelector('input').setAttribute('required', 'true');
        break;

      case 'offer_letter':
        startDateField.style.display = 'block';
        startDateField.querySelector('input').setAttribute('required', 'true');
        ctcField.style.display = 'block';
        ctcField.querySelector('input').setAttribute('required', 'true');
        startPositionField.style.display = 'block';
        startPositionField.querySelector('input').setAttribute('required', 'true');
        break;

      case 'relieving_letter':
        endDateField.style.display = 'block';
        endDateField.querySelector('input').setAttribute('required', 'true');
        endPositionField.style.display = 'block';
        endPositionField.querySelector('input').setAttribute('required', 'true');
        break;

      case 'payslip':
        payslipFields.style.display = 'block';
        payslip.style.display = 'block';
        document.querySelectorAll('#payslip-fields input').forEach(function (input) {
          input.setAttribute('required', 'true');
        });
        break;

      default:
        break;
    }
  }

  // Function to calculate totals for payslip
  function calculateTotals() {
    const basicSalary = parseFloat(document.getElementById("basic-salary")?.value) || 0;
    const hra = parseFloat(document.getElementById("hra")?.value) || 0;
    const incomeTax = parseFloat(document.getElementById("income-tax")?.value) || 0;
    const providentFund = parseFloat(document.getElementById("provident-fund")?.value) || 0;

    const grossEarnings = basicSalary + hra;
    const totalDeductions = incomeTax + providentFund;
    const netPayable = grossEarnings - totalDeductions;

    const grossEarningsField = document.getElementById("gross-earnings");
    const totalDeductionsField = document.getElementById("total-deductions");
    const netPayableField = document.getElementById("net-payable");

    if (grossEarningsField) grossEarningsField.value = grossEarnings.toFixed(2);
    if (totalDeductionsField) totalDeductionsField.value = totalDeductions.toFixed(2);
    if (netPayableField) netPayableField.value = netPayable.toFixed(2);
  }


  // Event listener for document type selection
  document.getElementById('document_type').addEventListener('change', toggleDocumentFields);

  // Event listener for payslip input changes
  const payslipInputs = ["basic-salary", "hra", "income-tax", "provident-fund"];
  payslipInputs.forEach((id) => {
    const input = document.getElementById(id);
    if (input) {
      input.addEventListener("input", calculateTotals);
    }
  });

  toggleDocumentFields();

});
