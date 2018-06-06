class Visit < ApplicationRecord
  belongs_to :department
  has_many :room_visits
  has_many :visit_files

  validates_presence_of :date
  validates_presence_of :institution
  before_create :set_status

  REQUESTED = 1
  APPROVED = 2
  CONFIRMED = 3
  CANCELED = 4
  FINISHED = 5
  DELETED = 99

  CAR = 1
  BUS = 2
  WALK = 3

  TRANSPORT_TYPE = {CAR => 'Automóvil', BUS => 'Autobus', WALK => 'Caminando'}

  STATUS = {
      REQUESTED => 'Solicitada',
      APPROVED => 'Aprobada',
      CONFIRMED => 'Confirmada',
      CANCELED => 'Cancelada',
      FINISHED => 'Finalizada',
  }

  def get_transport_type
    TRANSPORT_TYPE[self.transport_type]
  end

  def get_status
    STATUS[self.status]
  end

  def set_status
    if self.status.nil?
      self.status = REQUESTED
    end
  end

end
