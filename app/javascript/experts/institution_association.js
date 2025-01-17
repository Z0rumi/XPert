function initializeInstitutionSelect() {
  const radioButtons = document.querySelectorAll(".institution-association-radio");
  const institutionField = document.getElementById("institution-field");
  const cooperationOpportunityField = document.getElementById("cooperation-opportunity-field");

  function updateFieldVisibility() {
    if ( radioButtons.length && institutionField && cooperationOpportunityField) {
      const isYesSelected = document.getElementById("institution_yes").checked;

      if (isYesSelected) {
        institutionField.classList.remove("hidden");
        cooperationOpportunityField.classList.remove("hidden");
      } else {
        institutionField.classList.add("hidden");
        cooperationOpportunityField.classList.add("hidden");
      }
    }
    else {
      return;
    }
  }

  radioButtons.forEach((radio) => {
    radio.addEventListener("change", updateFieldVisibility);
  });

  updateFieldVisibility();
}

document.addEventListener("turbo:load", initializeInstitutionSelect);
document.addEventListener("turbo:render", initializeInstitutionSelect);
