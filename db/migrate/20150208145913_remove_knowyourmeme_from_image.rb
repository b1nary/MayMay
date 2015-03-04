class RemoveKnowyourmemeFromImage < ActiveRecord::Migration
  def change
    remove_column :memes, :knowyourmeme
  end
end
