class AddSplitToVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :split_in_groups, :boolean, default:0
  end
end
