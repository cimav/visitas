class Persona < NetmultixRecord

  self.table_name = "#{self.connection.current_database}.personas"

  def full_name
    "#{self.nombres} #{self.apellidos}"
  end
end