class Visma::EDIProvider < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.EDIProvider"
  self.primary_key = "EDIProviderNo"

  has_many :edi_transactions, foreign_key: "EDIProviderNo", class_name: Visma::EDITransaction
end
