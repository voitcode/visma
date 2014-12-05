class Visma::CustomerEdiProfile < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.CustomerEdiProfile"
  self.primary_key = "EdiProfileNo"

  has_many :edi_transactions, foreign_key: "EDIProfileNo", class_name: Visma::EDITransaction
end
