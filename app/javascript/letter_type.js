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

      default:
        break;
    }
  }

  toggleDocumentFields();

  document.getElementById('document_type').addEventListener('change', toggleDocumentFields);
});
