class Visma::CompanyDeliveryAddresses < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CompanyDeliveryAddresses"
  #self.primary_key = TODO
end
