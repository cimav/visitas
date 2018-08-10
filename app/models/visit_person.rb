class VisitPerson < ApplicationRecord
  belongs_to :visit
  validates_presence_of :name
  validates_presence_of :person_type

  STUDENT = 1
  TEACHER = 2
  DRIVER = 3
  STAFF = 4
  OTHER = 5

  PERSON_TYPES = {
      STUDENT => 'Estudiante',
      TEACHER => 'Docente',
      DRIVER => 'Chofer',
      STAFF => 'Personal administrativo',
      OTHER => 'Otro'
  }

  def get_type
    PERSON_TYPES[self.person_type]
  end

end
