class NetmultixRecord < ActiveRecord::Base

  establish_connection :"production_cimavnetmultix"
  self.abstract_class = true

  def self.table_name_prefix
    "cimavnetmultix."
  end
end