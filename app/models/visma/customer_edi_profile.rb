class Visma::CustomerEdiProfile < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerEdiProfile"
  self.primary_key = "EdiProfileNo"

  belongs_to :edi_provider, primary_key: "EDIProviderNo", foreign_key: "EDIProviderNo", class_name: Visma::EDIProvider
  has_many :edi_transactions, foreign_key: "EDIProfileNo", class_name: Visma::EDITransaction
end
