class RoomVisit < ApplicationRecord
  belongs_to :visit
  belongs_to :room
  belongs_to :persona
end
