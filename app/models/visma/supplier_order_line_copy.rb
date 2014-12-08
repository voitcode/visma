class Visma::SupplierOrderLineCopy < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "SupplierOrderLineCopy"
  self.primary_key = "SupplierOrderLineUniqueID"
end
