class Visma::CustomerOrder < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerOrder"
  self.primary_key = "OrderNo"

  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :customer, foreign_key: :CustomerNo
  belongs_to :chain, foreign_key: :ChainNo, primary_key: :CustomerNo, class_name: Visma::Customer

  has_many :customer_order_lines, foreign_key: :OrderNo
  alias :order_lines :customer_order_line
end
