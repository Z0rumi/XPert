import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select", "selectedTags"];

  connect() {
    console.log("TagSelectorController connected");

    // Prüfen, ob die erforderlichen Targets vorhanden sind
    if (this.hasSelectTarget && this.hasSelectedTagsTarget) {
      this.initializeSelectedTags();
      this.selectTarget.addEventListener("change", this.handleSelectChange.bind(this));
    } else {
      console.error("TagSelectorController: Missing required targets");
    }
  }

  // Initialisiere die vorhandenen Tags und füge Event-Listener hinzu
  initializeSelectedTags() {
    console.log("Initializing selected tags...");
    this.selectedTagsTarget.querySelectorAll(".remove-tag").forEach((button) => {
      button.addEventListener("click", this.removeTag.bind(this));
    });
  }

  // Verarbeite die Auswahl aus dem Dropdown
  handleSelectChange(event) {
    const selectedOption = this.selectTarget.options[this.selectTarget.selectedIndex];
    const value = selectedOption.value;
    const text = selectedOption.text;
    const paramName = this.selectTarget.dataset.paramName;

    if (!value) {
      console.warn("No value selected");
      return; // Verhindert leere Auswahl
    }

    // Verhindere doppelte Tags
    if (this.selectedTagsTarget.querySelector(`[data-value="${CSS.escape(value)}"]`)) {
      console.warn(`Tag with value "${value}" already exists.`);
      return;
    }

    // Erstelle ein neues Tag
    this.createTag(value, text, paramName);

    // Setze die Auswahl im Dropdown zurück
    this.selectTarget.selectedIndex = 0;
  }

  // Methode zum Erstellen eines neuen Tags
  createTag(value, text, paramName) {
    console.log(`Creating tag for value: ${value}, text: ${text}`);

    const tag = document.createElement("span");
    tag.classList.add(
      "tag",
      "flex",
      "items-center",
      "bg-custom-red",
      "text-white",
      "px-3",
      "py-1",
      "rounded-md",
      "gap-2",
      "mr-2",
      "mt-2"
    );
    tag.dataset.value = value;
    tag.innerHTML = `
      ${text}
      <button type="button" class="remove-tag ml-2 text-white font-bold">&times;</button>
    `;

    const input = document.createElement("input");
    input.type = "hidden";
    input.name = paramName;
    input.value = value;

    // Füge das Tag und das zugehörige versteckte Input-Feld hinzu
    this.selectedTagsTarget.appendChild(tag);
    this.selectedTagsTarget.appendChild(input);

    // Füge den Event-Listener zum Entfernen des Tags hinzu
    tag.querySelector(".remove-tag").addEventListener("click", () => {
      tag.remove();
      input.remove();
    });

    console.log(`Tag created: ${text}`);
  }

  // Methode zum Entfernen eines Tags
  removeTag(event) {
    const tag = event.target.closest(".tag");

    if (!tag) {
      console.error("No tag element found to remove.");
      return;
    }

    const value = tag.dataset.value;
    const input = this.selectedTagsTarget.querySelector(`input[value="${CSS.escape(value)}"]`);

    if (input) input.remove();
    tag.remove();

    console.log(`Tag with value "${value}" removed.`);
  }
}
