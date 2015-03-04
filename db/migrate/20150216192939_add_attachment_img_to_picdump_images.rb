class AddAttachmentImgToPicdumpImages < ActiveRecord::Migration
  def self.up
    change_table :picdump_images do |t|
      t.attachment :img
    end
  end

  def self.down
    remove_attachment :picdump_images, :img
  end
end
