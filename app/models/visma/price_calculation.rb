class Visma::PriceCalculation < Visma::Base
  self.table_name += 'PriceCalculation'
  self.primary_key = 'PriceCalculationNo'

  has_many :price_calculation_history, foreign_key: 'PriceCalculationNo'
end
