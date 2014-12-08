class Visma::EDITransaction < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "EDITransaction"
  self.primary_key = "UniqueNo"

  belongs_to :edi_provider, foreign_key: "EDIProviderNo", primary_key: "EDIProviderNo", class_name: Visma::EDIProvider
  belongs_to :edi_profile, foreign_key: "EDIProfileNo", primary_key: "EdiProfileNo", class_name: Visma::CustomerEdiProfile
  belongs_to :customer, foreign_key: "PartyID", primary_key: "CustomerNo", class_name: Visma::Customer
end
