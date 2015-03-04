class RemoveUserHashFromMemes < ActiveRecord::Migration
  def change
    remove_column :memes, :user_hash, :string
  end
end
