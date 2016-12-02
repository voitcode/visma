class Visma::PriceMarkupGroup < Visma::Base
  self.table_name += 'PriceMarkupGroup'
  self.primary_key = 'PriceMarkUpGrpNo'

  has_many :article, foreign_key: 'PriceMarkUpGroup'
end
