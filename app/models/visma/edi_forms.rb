class Visma::EDIForms < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "EDIForms"
  self.primary_key = "EDIFormNo"
end
