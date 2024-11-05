document.addEventListener('DOMContentLoaded', function() {
  function toggleUserFields(showNewUserFields) {
    const newUserFields = document.getElementById('new_user_fields');
    const userSelect = document.getElementById('document_user_id');

    if (newUserFields && userSelect) {
      newUserFields.style.display = showNewUserFields ? 'block' : 'none';
      userSelect.disabled = showNewUserFields;
    }
  }
  const existingUserRadio = document.getElementById('user_option_existing');
  const newUserRadio = document.getElementById('user_option_new');
  if (existingUserRadio && newUserRadio) {
    existingUserRadio.addEventListener('change', function() {
      toggleUserFields(false);
    });
    newUserRadio.addEventListener('change', function() {
      toggleUserFields(true);
    });
  }
  if (existingUserRadio.checked) {
    toggleUserFields(false);
  } else if (newUserRadio.checked) {
    toggleUserFields(true);
  }

});
