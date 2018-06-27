class Visit < ApplicationRecord
  belongs_to :department
  has_many :room_visits
  has_many :visit_files

  validates_presence_of :date
  validates_presence_of :institution
  before_create :set_status
  before_create :set_token
  after_create :send_email

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

  def set_token
    self.token = Digest::SHA256.hexdigest DateTime.now.to_s
  end

  def send_email
    VisitsMailer.new_visit(self).deliver_later
    puts "Se notificará a #{self.resp_email} sobre visita de #{self.institution} a #{self.department.name}"
  end

end
