class CreateInboxes < ActiveRecord::Migration[8.1]
  def change
    create_table :inboxes do |t|
      t.string :name
      t.string :summary
      t.string :source
      t.jsonb :payload, default: {}
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
