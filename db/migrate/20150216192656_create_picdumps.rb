class CreatePicdumps < ActiveRecord::Migration
  def change
    create_table :picdumps do |t|
      t.string :title
      t.integer :picdump_category_id
      t.string :description

      t.timestamps null: false
    end
  end
end
