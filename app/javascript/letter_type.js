document.addEventListener('DOMContentLoaded', function() {
  const documentTypeSelect = document.querySelector('[name="document[document_type]"]');
  const offerLetterFields = document.getElementById('offer_letter_fields');
  const experienceLetterFields = document.getElementById('experience_letter_fields');
  const relievingLetterFields = document.getElementById('relieving_letter_fields');
  const appointmentLetterFields = document.getElementById('appointment_letter_fields');

  function toggleFields() {
      const documentType = documentTypeSelect.value;

      offerLetterFields.style.display = 'none';
      experienceLetterFields.style.display = 'none';
      relievingLetterFields.style.display = 'none';
      appointmentLetterFields.style.display = 'none';

      if (documentType === "experience_letter") {
          experienceLetterFields.style.display = 'block';
      } else if (documentType === "offer_letter") {
          offerLetterFields.style.display = 'block';
      } else if (documentType === "relieving_letter") {
          relievingLetterFields.style.display = 'block';
      } else if (documentType === "appointment_letter") {
          appointmentLetterFields.style.display = 'block';
      }
  }

  documentTypeSelect.addEventListener('change', toggleFields);
  toggleFields();
});
