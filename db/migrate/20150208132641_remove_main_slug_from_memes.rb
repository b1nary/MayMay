class RemoveMainSlugFromMemes < ActiveRecord::Migration
  def change
    remove_column :memes, :main_slug
    remove_column :memes, :meme_slug_id
  end
end
