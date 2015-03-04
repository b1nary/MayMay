class RemoveSourceFromPicdumpImage < ActiveRecord::Migration
  def change
    remove_column :picdump_images, :source
  end
end
