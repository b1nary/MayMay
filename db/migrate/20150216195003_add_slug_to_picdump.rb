class AddSlugToPicdump < ActiveRecord::Migration
  def change
    add_column :picdumps, :slug, :string
    add_index :picdumps, :slug
  end
end
