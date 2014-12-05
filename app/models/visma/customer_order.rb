class Visma::CustomerOrder < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.CustomerOrder"
  self.primary_key = "OrderNo"

  belongs_to :customer, foreign_key: :CustomerNo

  has_many :order_line, foreign_key: :OrderNo, primary_key: :OrderNo, class_name: CustomerOrderLine
end
