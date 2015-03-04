class AddKnowyourmemeToMemes < ActiveRecord::Migration
  def change
    add_column :memes, :knowyourmeme, :string
  end
end
