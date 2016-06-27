class Visma::DebLBalance < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "DebLBalance"
  self.primary_key = "UniqueNo"
end
