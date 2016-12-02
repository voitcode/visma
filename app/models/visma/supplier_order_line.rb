class Visma::SupplierOrderLine < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "SupplierOrderLine"
  self.primary_key = "SuppliersOrderLineNo"
end
