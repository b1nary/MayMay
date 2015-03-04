class AddSlugToPicdumpCategory < ActiveRecord::Migration
  def change
    add_column :picdump_categories, :slug, :string
    add_index :picdump_categories, :slug
  end
end
