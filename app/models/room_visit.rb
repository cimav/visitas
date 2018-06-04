class RoomVisit < ApplicationRecord
  belongs_to :visit
  belongs_to :room
  belongs_to :persona

  SCHEDULED = 1
  CANCELED = 2
  FINISHED = 3

  STATUS = {
      SCHEDULED => 'Agendada',
      CANCELED => 'Cancelada',
      FINISHED => 'Finalizada'
  }

  def get_status
    STATUS[self.status]
  end
end
