class Visma::SupplierOrder < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "SupplierOrder"
  self.primary_key = "SupplierOrderNo"
end
