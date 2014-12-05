class Visma::ArticleEan < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.ArticleEAN"
  self.primary_key = "UnitTypeNo"

  belongs_to :unit_type, foreign_key: :UnitTypeNo, primary_key: :UnitTypeNo
  belongs_to :article, primary_key: :ArticleNo, foreign_key: :ArticleNo
end
