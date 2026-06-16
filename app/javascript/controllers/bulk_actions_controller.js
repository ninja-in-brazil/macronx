import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "selectAll", "actionButton"]

  connect() {
    this.updateActions()
  }

  selectAll(event) {
    const checked = event.target.checked
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = checked
    })
    this.updateActions()
  }

  updateActions() {
    const anyChecked = this.checkboxTargets.some(cb => cb.checked)
    this.actionButtonTargets.forEach(btn => {
      btn.disabled = !anyChecked
    })

    if (this.hasSelectAllTarget) {
      const allChecked = this.checkboxTargets.length > 0 &&
        this.checkboxTargets.every(cb => cb.checked)
      this.selectAllTarget.checked = allChecked
      this.selectAllTarget.indeterminate = anyChecked && !allChecked
    }
  }
}
