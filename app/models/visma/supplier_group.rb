class Visma::SupplierGroup < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "SupplierGroup"
  self.primary_key = "SupplierGrpNo"
end
