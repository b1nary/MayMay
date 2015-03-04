class AddImageToMemes < ActiveRecord::Migration
  def change
    add_column :memes, :image, :string
  end
end
