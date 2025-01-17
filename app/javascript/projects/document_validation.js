function initializeDocumentsValidation() {
    const documentsInput = document.getElementById('documentsInput');
  
    if (documentsInput) {
      documentsInput.addEventListener('change', (event) => {
        const allowedExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];
        const maxFileSize = 10 * 1024 * 1024; // 10MB
        const files = event.target.files;
  
        for (let i = 0; i < files.length; i++) {
          const file = files[i];
          const extension = file.name.split('.').pop().toLowerCase();
  
          if (!allowedExtensions.includes(extension)) {
            alert(`Ungültiges Dateiformat: ${file.name}. Bitte wählen Sie ein gültiges Dateiformat.`);
            event.target.value = '';
            break;
          }
  
          if (file.size > maxFileSize) {
            alert(`Dateigröße überschritten: ${file.name} ist größer als 10 MB.`);
            event.target.value = '';
            break;
          }
        }
      });
    }
  }
  
  document.addEventListener('turbo:load', initializeDocumentsValidation);
  document.addEventListener('turbo:render', initializeDocumentsValidation);