document.addEventListener('DOMContentLoaded', function() {
  const documentTypeSelect = document.querySelector('[name="document[document_type]"]');
  const offerLetterFields = document.getElementById('offer_letter_fields');
  const experienceLetterFields = document.getElementById('experience_letter_fields');
  const resignationLetterFields = document.getElementById('resignation_letter_fields');
  const incrementLetterFields = document.getElementById('increment_letter_fields');

  function toggleFields() {
      const documentType = documentTypeSelect.value;

      offerLetterFields.style.display = 'none';
      experienceLetterFields.style.display = 'none';
      resignationLetterFields.style.display = 'none';
      incrementLetterFields.style.display = 'none';

      if (documentType === "experience_letter") {
          experienceLetterFields.style.display = 'block';
      } else if (documentType === "offer_letter") {
          offerLetterFields.style.display = 'block';
      } else if (documentType === "resign_letter") {
          resignationLetterFields.style.display = 'block';
      } else if (documentType === "increment_letter") {
          incrementLetterFields.style.display = 'block';
      }
  }

  documentTypeSelect.addEventListener('change', toggleFields);
  toggleFields();
});
