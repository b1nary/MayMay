class AddCategoryIdToPicdumpImages < ActiveRecord::Migration
  def change
    add_column :picdump_images, :picdump_category_id, :integer
  end
end
