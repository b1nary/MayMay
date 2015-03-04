class CreateMemeSlugs < ActiveRecord::Migration
  def change
    create_table :meme_slugs do |t|
      t.integer :meme_id
      t.string :slug

      t.timestamps null: false
    end
  end
end
