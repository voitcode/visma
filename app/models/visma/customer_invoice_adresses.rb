class Visma::CustomerInvoiceAdresses < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerInvoiceAdresses"
  self.primary_key = "InvoiceAdressNo"
end
