class MigrateApiTokenToDigest < ActiveRecord::Migration[8.1]
  def up
    remove_index  :users, :api_token
    remove_column :users, :api_token
    add_column    :users, :api_token_digest, :string
    add_index     :users, :api_token_digest, unique: true
  end

  def down
    remove_index  :users, :api_token_digest
    remove_column :users, :api_token_digest
    add_column    :users, :api_token, :string
    add_index     :users, :api_token, unique: true
  end
end
