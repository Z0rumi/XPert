import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "selectedTags"]

  connect() {
    this.paramName = this.element.dataset.tagSelectorParamName // read the param name from data attribute
    this.initializeExistingTags()
    this.selectTarget.addEventListener('change', this.addTag.bind(this))
  }

  disconnect() {
    this.selectTarget.removeEventListener('change', this.addTag.bind(this))
  }

  initializeExistingTags() {
    this.selectedTagsTarget.querySelectorAll('.tag').forEach(tag => {
      const removeButton = tag.querySelector('.remove-tag')
      removeButton.addEventListener('click', () => {
        const input = this.selectedTagsTarget.querySelector(`input.category-input[value="${tag.dataset.id}"]`)
        if (input) input.remove()
        tag.remove()
      })
    })
  }

  addTag(event) {
    const select = this.selectTarget
    const selectedOption = select.options[select.selectedIndex]
    const value = selectedOption.value
    const displayName = selectedOption.text

    if (value && !this.selectedTagsTarget.querySelector(`.tag[data-id="${value}"]`)) {
      const tag = document.createElement('span')
      tag.className = 'tag flex items-center bg-blue-200 text-blue-800 px-2 py-1 rounded mr-2 mt-2'
      tag.dataset.id = value
      tag.innerHTML = `
        ${displayName}
        <button type="button" class="remove-tag ml-2 text-red-500 hover:text-red-700">&times;</button>
      `

      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = this.paramName // use the dynamic param name
      input.value = value
      input.classList.add('category-input')

      this.selectedTagsTarget.appendChild(tag)
      this.selectedTagsTarget.appendChild(input)

      tag.querySelector('.remove-tag').addEventListener('click', () => {
        tag.remove()
        input.remove()
      })
    }

    select.selectedIndex = 0
  }
}