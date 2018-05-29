class Visit < ApplicationRecord
  belongs_to :department
  has_many :room_visits
  validates_presence_of :date
  validates_presence_of :institution

  CAR = 1
  BUS = 2
  WALK = 3

  TRANSPORT_TYPE = {CAR => 'Automovil', BUS => 'Autobus', WALK => 'Caminando'}

  def get_transport_type
    TRANSPORT_TYPE[self.transport_type]
  end

end
