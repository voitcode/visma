class Visma::CustomerOrderLine < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.CustomerOrderLine"
  self.primary_key = :UniqueID

  belongs_to :customer_order, foreign_key: :OrderNo, primary_key: :OrderNo
end
