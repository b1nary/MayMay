class CreateMemeViews < ActiveRecord::Migration
  def change
    create_table :meme_views do |t|
      t.string :user_hash
      t.integer :generated_meme_id

      t.timestamps null: false
    end
  end
end
