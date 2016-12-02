class Visma::DiscountGroupArticle < Visma::Base
  self.table_name += 'DiscountGroupArticle'
  self.primary_key = 'DiscountGrpArtNo'
  enum InActiveYesNo: [:active, :inactive]
end
