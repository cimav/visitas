class SaposModels < ActiveRecord::Base
  self.abstract_class = true
  establish_connection SAPOS_DB
end