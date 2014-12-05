class Visma::CompanyDeliveryAddresses < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.CompanyDeliveryAddresses"
  #self.primary_key = TODO
end
