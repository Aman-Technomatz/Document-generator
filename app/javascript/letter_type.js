document.addEventListener('DOMContentLoaded', function() {
  const documentTypeSelect = document.querySelector('[name="document[document_type]"]');
  const offerLetterFields = document.getElementById('offer_letter_fields');
  const experienceLetterFields = document.getElementById('experience_letter_fields');
  const resignationLetterFields = document.getElementById('resignation_letter_fields');
  const incrementLetterFields = document.getElementById('increment_letter_fields');
  const applicationLetterFields = document.getElementById('application_letter_fields');
  function toggleFields() {
    const documentType = documentTypeSelect.value;
    offerLetterFields.style.display = 'none';
    experienceLetterFields.style.display = 'none';
    resignationLetterFields.style.display = 'none';
    applicationLetterFields.style.display = 'none';
    incrementLetterFields.style.display = 'none';
    if (documentType === "experience_letter") {
      experienceLetterFields.style.display = 'block';
    } else if (documentType === "Offer Letter") {
      offerLetterFields.style.display = 'block';
    }
    else if (documentType === "Resign Letter") {
      resignationLetterFields.style.display = 'block';
    }
    else if (documentType === "Increment Letter") {
      incrementLetterFields.style.display = 'block';
    }
    else if (documentType === "Application Letter") {
      applicationLetterFields.style.display = 'block';
    }
  }

  documentTypeSelect.addEventListener('change', toggleFields);
  toggleFields();
});
