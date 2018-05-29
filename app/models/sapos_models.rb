class SaposModels < ActiveRecord::Base
  self.abstract_class = true
  establish_connection SAPOS_DB

  def self.table_name_prefix
    "sapos_#{Rails.env}."
  end
end