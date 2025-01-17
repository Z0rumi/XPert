import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal"];
  
  connect() {
  }

  showModal(e) {
    e.preventDefault();
    this.modalTarget.classList.remove('hidden');
    this.modalTarget.classList.add('block');
  }

  hideModal() {
    this.modalTarget.classList.remove('block');
    this.modalTarget.classList.add('hidden');
  }
}