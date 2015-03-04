class CreateMemes < ActiveRecord::Migration
  def change
    create_table :memes do |t|
      t.string :title
      t.text :description
      t.string :keywords
      t.integer :fame
      t.integer :fame_day
      t.integer :fame_week
      t.integer :fame_month

      t.timestamps null: false
    end
  end
end
