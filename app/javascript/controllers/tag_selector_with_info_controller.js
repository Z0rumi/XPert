import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "selectedTags"]

  connect() {
    this.paramName = this.element.dataset.tagSelectorWithInfoParamName

    this.infoIconUrl = this.element.dataset.tagSelectorWithInfoInfoIconUrl || "/assets/info_icon_white.png"

    this.initializeExistingTags()
    this.selectTarget.addEventListener('change', this.addTag.bind(this))
  }

  disconnect() {
    this.selectTarget.removeEventListener('change', this.addTag.bind(this))
  }

  initializeExistingTags() {
    // Löschen Event für bereits gerrenderte Tags
    this.selectedTagsTarget.querySelectorAll('.tag').forEach(tag => {
      const removeButton = tag.querySelector('.remove-tag')
      removeButton.addEventListener('click', () => {
        const input = this.selectedTagsTarget.querySelector(`input[value="${tag.dataset.id}"]`)
        if (input) input.remove()
        tag.remove()
      })
    })
  }

  addTag(event) {
    const selectedOption = this.selectTarget.options[this.selectTarget.selectedIndex]
    const value = selectedOption.value
    const displayName = selectedOption.text
    const itemUrl = selectedOption.dataset.url

    // Check, ob Element bereits ausgewählt
    if (value && !this.selectedTagsTarget.querySelector(`.tag[data-id="${value}"]`)) {
      const tag = document.createElement('span')
      tag.className = 'tag flex items-center bg-blue-200 text-blue-800 px-2 py-1 rounded mr-2 mt-2'
      tag.dataset.id = value

      // HTML für ein Tag mit Info Button
      tag.innerHTML = `
        <div>
          <a href="${itemUrl}" data-turbo-frame="show_modal">
            <img src="${this.infoIconUrl}" class="w-4 h-4 flex-shrink-0" alt="Info icon" />
          </a>
        </div>
        <div class="ml-[5px]">
          ${displayName}
        </div>
        <button type="button" class="remove-tag ml-2 text-red-500 hover:text-red-700">&times;</button>
      `

      // Hidden Input für Formular
      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = this.paramName
      input.value = value

      // Tag und Input an Container hängen
      this.selectedTagsTarget.appendChild(tag)
      this.selectedTagsTarget.appendChild(input)

      // Löschen Event für Tag binden
      tag.querySelector('.remove-tag').addEventListener('click', () => {
        tag.remove()
        input.remove()
      })
    }

    // Reset select für Platzhalter
    this.selectTarget.selectedIndex = 0
  }
}