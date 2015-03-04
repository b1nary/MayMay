class AddSlugIndex < ActiveRecord::Migration
  def change
    add_index :meme_slugs, :slug, :unique => true
  end
end
