class Visma::CustomerSum < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerSum"
  self.primary_key = "CustomerNo"

  belongs_to :customer, foreign_key: "CustomerNo"
end
