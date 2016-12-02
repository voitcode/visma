class Visma::CustomerBonusProfileLine < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerBonusProfileLine"
  #self.primary_key = TODO
end
