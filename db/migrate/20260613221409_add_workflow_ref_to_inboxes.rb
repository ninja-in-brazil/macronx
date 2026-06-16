class AddWorkflowRefToInboxes < ActiveRecord::Migration[8.1]
  def change
    add_reference :inboxes, :workflow, null: true, foreign_key: true
  end
end
