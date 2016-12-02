class Visma::ArtType < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "ArtType"
  #self.primary_key = TODO
end
