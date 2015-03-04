class RemoveUserHashFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :user_hash, :string
  end
end
