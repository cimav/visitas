class Departamento < NetmultixRecord
  self.table_name = "#{self.connection.current_database}.departamentos"
end