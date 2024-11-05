document.addEventListener("DOMContentLoaded", function() {
    const documentTypeSelect = document.getElementById("document_type");
    const commonFields = document.getElementById("common_fields");
    const appointmentLetterFields = document.getElementById("appointment_letter_fields");
    const experienceLetterFields = document.getElementById("experience_letter_fields");
    const relievingLetterFields = document.getElementById("relieving_letter_fields");
    const incrementLetterFields = document.getElementById("increment_letter_fields");

    function toggleFields() {
      commonFields.style.display = "none";
      appointmentLetterFields.style.display = "none";
      experienceLetterFields.style.display = "none";
      relievingLetterFields.style.display = "none";
      incrementLetterFields.style.display = "none";
      const selectedDocumentType = documentTypeSelect.value;
      if (selectedDocumentType === "offer_letter" || selectedDocumentType === "appointment_letter") {
        commonFields.style.display = "block";
        if (selectedDocumentType === "appointment_letter") {
          appointmentLetterFields.style.display = "block";
        }
      } else if (selectedDocumentType === "experience_letter") {
        commonFields.style.display = "block";
        experienceLetterFields.style.display = "block";
      } else if (selectedDocumentType === "relieving_letter") {
        relievingLetterFields.style.display = "block";
      } else if (selectedDocumentType === "increment_letter") {
        incrementLetterFields.style.display = "block";
      }
      if (selectedDocumentType !== "") {
        document.getElementById('start_date').setAttribute('required', 'true');
        document.getElementById('start_position').setAttribute('required', 'true');
      }
    }
    toggleFields();
    documentTypeSelect.addEventListener("change", toggleFields);
  });
