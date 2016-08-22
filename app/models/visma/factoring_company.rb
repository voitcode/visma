class Visma::FactoringCompany < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "FactoringCompany"
  self.primary_key = "FactNo"
end