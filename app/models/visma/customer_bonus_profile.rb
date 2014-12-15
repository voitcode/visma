class Visma::CustomerBonusProfile < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerBonusProfile"
  self.primary_key = "CustomerBonusProfileNo"
end
