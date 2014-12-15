class Visma::PriceMarkupGroup < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "PriceMarkupGroup"
  self.primary_key = "PriceMarkUpGrpNo"

  has_many :article, foreign_key: "PriceMarkUpGroup"
end
