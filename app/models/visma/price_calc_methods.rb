class Visma::PriceCalcMethods < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "PriceCalcMethods"
  self.primary_key = "PriceCalcMethodsNo"
end
