class Visma::PriceCalculationHistory < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "PriceCalculationHistory"
  #self.primary_key = TODO

  belongs_to :price_calculation, foreign_key: "PriceCalculationNo"
end
