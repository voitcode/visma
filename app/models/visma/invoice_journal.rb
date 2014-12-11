class Visma::InvoiceJournal < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "InvoiceJournal"
  self.primary_key = "InvoiceNo"
end
