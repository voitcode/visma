class Visma::CustomerDeliveryAddresses < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerDeliveryAddresses"
  self.primary_key = :DeliveryAddressNo
end
