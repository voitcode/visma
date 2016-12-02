class Visma::DebLHistory < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "DebLHistory"
  self.primary_key = "UniqueNo"
end
