class Visma::CustomerInvoiceAdresses < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.CustomerInvoiceAdresses"
  self.primary_key = "InvoiceAdressNo"
end
