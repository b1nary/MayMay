class CreateGeneratedMemes < ActiveRecord::Migration
  def change
    create_table :generated_memes do |t|
      t.string :top
      t.string :bottom
      t.integer :meme_id
      t.string :slug
      t.string :hash
      t.integer :user_id
      t.integer :views
      t.integer :views_day
      t.integer :views_week
      t.integer :views_month

      t.timestamps null: false
    end
  end
end
