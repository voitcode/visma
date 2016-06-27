class Visma::CredLHistory < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CredLHistory"
  self.primary_key = "UniqueNo"
end
