class User < ApplicationRecord
  serialize :departments, Array

  ADMIN = 1
  ASSISTANT = 2
  SUPER_USER = 1000

  TYPES = {
      ADMIN => 'Administrador',
      ASSISTANT => 'Asistente',
      SUPER_USER => 'Súper Usuario'
  }

  def get_user_departments
    departments = ''
    self.departments.each do |department|
      departments+= " #{Department.find(department).name},"
    end
    departments.chop
  end

  def get_type
    TYPES[self.user_type]
  end

end
