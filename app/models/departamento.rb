class Departamento < NetmultixRecord
  self.table_name = "#{self.connection.current_database}.departamentos"

  has_many :rooms
  has_many :visits
end