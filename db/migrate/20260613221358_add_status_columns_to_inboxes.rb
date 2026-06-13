class AddStatusColumnsToInboxes < ActiveRecord::Migration[8.1]
  def change
    add_column :inboxes, :processed, :boolean, default: false, null: false
    add_column :inboxes, :archived, :boolean, default: false, null: false
  end
end
