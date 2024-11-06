document.addEventListener('DOMContentLoaded', function () {
  function toggleDocumentFields() {
    const docType = document.getElementById('document_type').value;

    document.querySelectorAll('.conditional-fields').forEach(function (field) {
      field.style.display = 'none';
      field.querySelectorAll('input, select, textarea').forEach(function (input) {
        input.removeAttribute('required');
      });
    });

    document.querySelectorAll('#common_fields input').forEach(function (input) {
      input.setAttribute('required', 'true');
    });

    switch (docType) {
      case 'appointment_letter':
        document.getElementById('appointment_letter_fields').style.display = 'block';
        document.querySelectorAll('#appointment_letter_fields input').forEach(function (input) {
          input.setAttribute('required', 'true');
        });
        break;

      case 'experience_letter':
        document.getElementById('experience_letter_fields').style.display = 'block';
        document.querySelectorAll('#experience_letter_fields input').forEach(function (input) {
          input.setAttribute('required', 'true');
        });
        break;

      case 'relieving_letter':
        document.getElementById('relieving_letter_fields').style.display = 'block';
        document.querySelectorAll('#relieving_letter_fields input').forEach(function (input) {
          input.setAttribute('required', 'true');
        });
        break;

      default:
        break;
    }
  }

  toggleDocumentFields();

  document.getElementById('document_type').addEventListener('change', toggleDocumentFields);
});
