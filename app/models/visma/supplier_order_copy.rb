class Visma::SupplierOrderCopy < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "SupplierOrderCopy"
  self.primary_key = "SupplierOrderCopyNo"
end
