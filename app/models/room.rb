class Room < ApplicationRecord
  belongs_to :departamento
  has_many :room_visits
end
