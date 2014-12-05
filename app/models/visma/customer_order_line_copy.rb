class Visma::CustomerOrderLineCopy < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.CustomerOrderLineCopy"
  self.primary_key = "OrderCopyNo"
end
