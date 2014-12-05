class Visma::InvoiceJournal < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.InvoiceJournal"
end
