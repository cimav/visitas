class Visit < ApplicationRecord
  belongs_to :department
  has_many :room_visits
  has_many :visit_files
  has_many :visit_people

  validates_presence_of :date
  validates_presence_of :institution
  before_create :set_status
  before_create :set_token
  after_create :send_requested_email
  after_create :send_notice_admin_email

  REQUESTED = 1
  APPROVED = 2
  CONFIRMED = 3
  CANCELED = 4
  FINISHED = 5
  DELETED = 99

  CAR = 1
  BUS = 2
  WALK = 3

  TOUR = 1
  WORKSHOP = 2
  PRACTICE = 3

  VISIT_TYPES = {TOUR => 'Recorrido', WORKSHOP => 'Taller', PRACTICE => 'Práctica de laboratorio'}

  TRANSPORT_TYPES = {CAR => 'Automóvil', BUS => 'Autobus', WALK => 'Caminando'}

  STATUS = {
      REQUESTED => 'Solicitada',
      APPROVED => 'Aprobada',
      CONFIRMED => 'Confirmada',
      CANCELED => 'Cancelada',
      FINISHED => 'Finalizada',
  }

  def get_transport_type
    TRANSPORT_TYPES[self.transport_type]
  end

  def get_status
    STATUS[self.status]
  end

  def get_visit_type
    VISIT_TYPES[self.visit_type]
  end

  def set_status
    if self.status.nil?
      self.status = REQUESTED
    end
  end

  def set_token
    self.token = Digest::SHA256.hexdigest DateTime.now.to_s
  end

  def send_requested_email
    VisitsMailer.new_visit(self).deliver_later
    puts "[SOLICITUD] Se notificará a #{self.resp_email} sobre visita de #{self.institution} a #{self.department.name}"

    # También se envía correo al asistente del departamento para que esté enterado de la visita
    if !self.department.assistant_email.blank?
      VisitsMailer.notice_assistant_new_visit(self).deliver_later
      puts "[NOTIFICACIÓN] Se notificará al asistente de #{self.department.name} #{self.department.assistant_email} sobre visita de #{self.institution}"
    end
  end

  def send_notice_admin_email
    User.where(user_type:User::ADMIN).each do |user|
      VisitsMailer.notice_admin_new_visit(self, user.email).deliver_later
      puts "[NOTIFICACIÓN] Se notificará al administrador sobre visita de #{self.institution} a #{self.department.name}"
    end
  end

  def send_approved_email
    VisitsMailer.visit_approved(self).deliver_later
    puts "[APROBADA] Se notificará a #{self.resp_email} sobre visita de #{self.institution} a #{self.department.name}"
  end

  def send_confirmed_email
    VisitsMailer.visit_confirmed(self, self.resp_email).deliver_later
    puts "[CONFIRMADA] Se notificará a #{self.resp_email} sobre visita de #{self.institution} a #{self.department.name}"

    User.where(user_type:User::ADMIN).each do |user|
      VisitsMailer.visit_confirmed(self, user.email).deliver_later
      puts "[CONFIRMADA] Se notificará al administrador sobre visita de #{self.institution} a #{self.department.name}"
    end
  end


end
