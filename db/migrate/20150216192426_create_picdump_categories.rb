class CreatePicdumpCategories < ActiveRecord::Migration
  def change
    create_table :picdump_categories do |t|
      t.string :title
      t.string :description

      t.timestamps null: false
    end
  end
end
