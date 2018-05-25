class Visit < ApplicationRecord
  belongs_to :departamento
  belongs_to :institution
  has_many :room_visits
end
