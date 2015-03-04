class AddMainToMemeSlugs < ActiveRecord::Migration
  def change
    add_column :meme_slugs, :main, :boolean
  end
end
