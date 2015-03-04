class RenameHashInGeneratedMemes < ActiveRecord::Migration
  def change
  	rename_column :generated_memes, :hash, :img_hash
  end
end
