class Visma::CustomerDeliveryAddresses < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.CustomerDeliveryAddresses"
  self.primary_key = :DeliveryAddressNo
end
