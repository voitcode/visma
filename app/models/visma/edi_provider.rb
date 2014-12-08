class Visma::EDIProvider < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "EDIProvider"
  self.primary_key = "EDIProviderNo"

  has_many :edi_transactions, foreign_key: "EDIProviderNo", class_name: Visma::EDITransaction
end
