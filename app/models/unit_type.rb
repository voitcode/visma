class Visma::UnitType < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.UnitType"
  self.primary_key = "UnitTypeNo"

  # Don't query UnitTypes where the sales unit is inactive
  default_scope { where("CAST(UnitInSales AS integer) != 1") }

  belongs_to :article, primary_key: :ArticleNo, foreign_key: :ArticleNo

  has_one :article_ean, primary_key: :UnitTypeNo, foreign_key: :UnitTypeNo
end
