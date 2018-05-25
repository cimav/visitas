class Persona < NetmultixRecord

  self.table_name = "#{self.connection.current_database}.personas"

  has_many :room_visits

  def full_name
    "#{self.nombres} #{self.apellidos}"
  end
end