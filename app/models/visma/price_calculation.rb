class Visma::PriceCalculation < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "PriceCalculation"
  self.primary_key = "PriceCalculationNo"

  has_many :price_calculation_history, foreign_key: "PriceCalculationNo"
end
