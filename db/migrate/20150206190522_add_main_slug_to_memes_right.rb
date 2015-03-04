class AddMainSlugToMemesRight < ActiveRecord::Migration
  def change
    add_column :memes, :meme_slug_id, :integer
  end
end
