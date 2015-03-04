class AddAttachmentImgToMemes < ActiveRecord::Migration
  def self.up
    change_table :memes do |t|
      t.attachment :img
    end
  end

  def self.down
    remove_attachment :memes, :img
  end
end
