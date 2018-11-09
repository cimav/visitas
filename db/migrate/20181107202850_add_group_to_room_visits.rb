class AddGroupToRoomVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :room_visits, :group, :string

  end
end
