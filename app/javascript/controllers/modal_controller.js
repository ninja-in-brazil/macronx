import { Controller } from "@hotwired/stimulus"

// Adds keyboard behaviour to modal dialogs:
//   Escape  → clicks the cancel target (closes the modal)
//   Enter   → clicks the submit target (submits the form)
//             skipped when a <select> is focused so dropdown navigation still works
export default class extends Controller {
  static targets = ["cancel", "submit"]

  connect() {
    this.handleKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.handleKeydown)

    // Move focus into the modal so keyboard events are predictable
    const firstFocusable = this.element.querySelector("select, input:not([type=hidden]), textarea, button")
    firstFocusable?.focus()
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown)
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      event.preventDefault()
      this.hasCancelTarget && this.cancelTarget.click()
      return
    }

    if (event.key === "Enter") {
      // Let the select handle Enter itself (opens/closes dropdown)
      if (document.activeElement?.tagName === "SELECT") return
      // Already on the submit button — browser handles it
      if (this.hasSubmitTarget && document.activeElement === this.submitTarget) return
      if (event.ctrlKey || event.metaKey || event.altKey) return

      event.preventDefault()
      this.hasSubmitTarget && this.submitTarget.click()
    }
  }
}
