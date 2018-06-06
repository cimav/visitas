class VisitFile < ApplicationRecord
  mount_uploader :file, VisitFileUploader
  belongs_to :visit
  after_destroy :delete_file

  INSTITUTION_REQUEST = 1
  INSURANCE = 2
  ATTENDANCE_LIST = 3

  FILE_TYPES = {
      INSTITUTION_REQUEST => 'Solicitud de la institución',
      INSURANCE => 'Póliza de seguro',
      ATTENDANCE_LIST => 'Lista de asistencia'
  }

  def delete_file
    remove_file!
  end

end
