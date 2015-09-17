class Visma::CustomerOrderLineCopy < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerOrderLineCopy"
  self.primary_key = "OrderCopyNo"

  include Visma::CreatedScopes
  belongs_to :customer_order_copy, foreign_key: :OrderCopyNo, primary_key: :OrderCopyNo
end
