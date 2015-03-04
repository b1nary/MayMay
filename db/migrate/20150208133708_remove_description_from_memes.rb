class RemoveDescriptionFromMemes < ActiveRecord::Migration
  def change
    remove_column :memes, :description
  end
end
