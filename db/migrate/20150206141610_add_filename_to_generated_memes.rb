class AddFilenameToGeneratedMemes < ActiveRecord::Migration
  def change
    add_column :generated_memes, :filename, :string
  end
end
