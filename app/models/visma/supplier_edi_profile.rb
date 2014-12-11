class Visma::SupplierEdiProfile < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "SupplierEdiProfile"
  self.primary_key = "SupplierEdiProfileNo"
end
