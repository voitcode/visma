class Visma::DiscountGroupArticle < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "DiscountGroupArticle"
  self.primary_key = "DiscountGrpArtNo"
  enum :InActiveYesNo => [ :active, :inactive ]
end
