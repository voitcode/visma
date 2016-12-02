class Visma::PriceCalculationHistory < Visma::Base
  self.table_name += 'PriceCalculationHistory'
  # self.primary_key = TODO

  belongs_to :price_calculation, foreign_key: 'PriceCalculationNo'
end
