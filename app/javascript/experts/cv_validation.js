function initializeCvValidation() {
    const cvInput = document.getElementById('cvInput');

    if (cvInput) {
      cvInput.addEventListener('change', (event) => {
        const allowedExtensions = ['pdf', 'png', 'jpg', 'jpeg'];
        const maxFileSize = 10 * 1024 * 1024; //10MB
        const files = event.target.files;
  
        for (let i = 0; i < files.length; i++) {
          const file = files[i];
          const extension = file.name.split('.').pop().toLowerCase();
  
          if (!allowedExtensions.includes(extension)) {
            alert(`Ungültiges Dateiformat: ${file.name}. Bitte wählen Sie ein gültiges Dateiformat (.pdf, .png, .jpg, .jpeg oder .zip)`);
            event.target.value = '';
            break;
          }

          if (file.size > maxFileSize) {
            alert(`Dateigröße überschritten: ${file.name} ist größer als 10 MB. Bitte wählen Sie eine kleinere Datei.`);
            event.target.value = '';
            break;
          }
        }
      });
    }
}

document.addEventListener('turbo:load', initializeCvValidation);
document.addEventListener('turbo:render', initializeCvValidation);