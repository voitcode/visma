class Visma::Units < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "Units"
  #self.primary_key = TODO
end
