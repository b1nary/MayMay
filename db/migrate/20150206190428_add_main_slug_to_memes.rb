class AddMainSlugToMemes < ActiveRecord::Migration
  def change
    add_column :memes, :main_slug, :string
  end
end
