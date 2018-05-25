class CreateRoomVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :room_visits do |t|
      t.datetime :date
      t.integer :status
      t.references :visit, foreign_key: true
      t.references :room, foreign_key: true
      t.references :persona, foreign_key: false

      t.timestamps
    end
  end
end
