class AddVisibleToPicdump < ActiveRecord::Migration
  def change
    add_column :picdumps, :visible, :boolean
  end
end
