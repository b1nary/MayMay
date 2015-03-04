class AddAttachmentHeaderToPicdumpCategories < ActiveRecord::Migration
  def self.up
    change_table :picdump_categories do |t|
      t.attachment :header
    end
  end

  def self.down
    remove_attachment :picdump_categories, :header
  end
end
