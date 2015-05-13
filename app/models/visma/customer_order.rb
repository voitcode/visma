class Visma::CustomerOrder < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerOrder"
  self.primary_key = "OrderNo"

  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :customer, foreign_key: :CustomerNo

  has_many :order_line, foreign_key: :OrderNo, primary_key: :OrderNo, class_name: CustomerOrderLine
end
