class AddUserHashToMemes < ActiveRecord::Migration
  def change
    add_column :memes, :user_hash, :string
  end
end
