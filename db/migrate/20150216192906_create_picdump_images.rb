class CreatePicdumpImages < ActiveRecord::Migration
  def change
    create_table :picdump_images do |t|
      t.integer :picdump_id
      t.string :title
      t.string :source

      t.timestamps null: false
    end
  end
end
