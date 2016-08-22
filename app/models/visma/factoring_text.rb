class Visma::FactoringText < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "FactoringText"
  self.primary_key = "FactNo"
end
