class Visma::SupplierEdiProfile < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "SupplierEdiProfile"
  self.primary_key = "SupplierEdiProfileNo"

  belongs_to :edi_provider, primary_key: "EDIProviderNo", foreign_key: "EDIProviderNo", class_name: Visma::EDIProvider
end
