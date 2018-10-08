class RemoveForeignKeyToRoomVisits < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :room_visits, :rooms
  end
end
