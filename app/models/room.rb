class Room < ApplicationRecord
  belongs_to :department
  has_many :room_visits
end
