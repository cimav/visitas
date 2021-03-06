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

  REQUESTED = 1
  APPROVED = 2
  CONFIRMED = 3
  CANCELED = 4
  FINISHED = 5
  PRE_APPROVED = 6
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
      PRE_APPROVED => 'Pre-aprobada',
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
    # se le envía correo al responsable
    VisitsMailer.new_visit(self).deliver_later
    puts "[#{DateTime.now.to_s}][SOLICITUD] Se notificará a #{self.resp_email} sobre visita de #{self.institution} a #{self.department.name} (id: #{self.id})"

    # También se envía correo al administrador para que le dé seguimiento a la visita
    User.where(user_type:User::ADMIN).each do |user|
      VisitsMailer.new_visit_admin(self, user.email).deliver_later
      puts "[#{DateTime.now.to_s}][NOTIFICACIÓN] Se notificará al administrador sobre visita de #{self.institution} a #{self.department.name} (id: #{self.id})"
    end

    # También se envía correo al asistente del departamento para que le dé seguimiento a la visita
    User.where(user_type:User::ASSISTANT).each do |assistant|
      if assistant.departments.include? self.department_id
        VisitsMailer.new_visit_assistant(self, assistant.email).deliver_later
        puts "[#{DateTime.now.to_s}][NOTIFICACIÓN] Se notificará a #{assistant.name} sobre visita de #{self.institution} (id: #{self.id})"
      end
    end

  end

  def send_pre_approved_email
    User.where(user_type:User::ADMIN).each do |user|
      VisitsMailer.visit_pre_approved(self, user.email).deliver_later
      puts "[#{DateTime.now.to_s}][PRE-APROBADA] Se notificará al administrador sobre visita de #{self.institution} a #{self.department.name} (id: #{self.id})"
    end
  end

  def send_approved_email
    VisitsMailer.visit_approved(self).deliver_later
    puts "[#{DateTime.now.to_s}][APROBADA] Se notificará a #{self.resp_email} sobre visita de #{self.institution} a #{self.department.name} (id: #{self.id})"
  end

  def send_confirmed_email
    VisitsMailer.visit_confirmed(self).deliver_later
    puts "[#{DateTime.now.to_s}][CONFIRMADA] Se notificará a #{self.resp_email} sobre visita de #{self.institution} a #{self.department.name} (id: #{self.id})"


    User.where(user_type:User::ADMIN).each do |user|
      VisitsMailer.visit_confirmed_admin(self, user.email).deliver_later
      puts "[#{DateTime.now.to_s}][CONFIRMADA] Se notificará al administrador sobre visita de #{self.institution} a #{self.department.name} (id: #{self.id})"
    end

    User.where(user_type:User::SUPERVISOR).each do |user|
      VisitsMailer.visit_confirmed_supervisor(self, user.email).deliver_later
      puts "[#{DateTime.now.to_s}][CONFIRMADA] Se notificará al supervisor sobre visita de #{self.institution} a #{self.department.name} (id: #{self.id})"
    end

    User.where(user_type:User::ASSISTANT).each do |assistant|
      if assistant.departments.include? self.department_id
        VisitsMailer.visit_confirmed_admin(self, assistant.email).deliver_later
        puts "[#{DateTime.now.to_s}][CONFIRMADA] Se notificará a #{assistant.name} sobre visita de #{self.institution} (id: #{self.id})"
      end
    end
  end

  def send_confirm_email_technician
    self.room_visits.where(status: RoomVisit::SCHEDULED).each do |room_visit|
      if room_visit.persona.cuenta_cimav
        VisitsMailer.visit_confirmed_technician(room_visit).deliver_later
        puts "[#{DateTime.now.to_s}][CONFIRMAR VISITA] Se notificará a #{room_visit.persona.nombre} sobre visita de #{room_visit.visit.institution} (id: #{self.id})"
      end
    end
  end


end
