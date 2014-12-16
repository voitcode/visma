class Visma::ShipmentType < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "ShipmentType"
  self.primary_key = "ShipmentTypeNo"
end
