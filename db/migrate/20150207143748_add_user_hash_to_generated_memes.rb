class AddUserHashToGeneratedMemes < ActiveRecord::Migration
  def change
    add_column :generated_memes, :user_hash, :string
  end
end
