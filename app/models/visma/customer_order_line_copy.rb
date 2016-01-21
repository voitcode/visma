class Visma::CustomerOrderLineCopy < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerOrderLineCopy"
  self.primary_key = :UniqueID

  include Visma::StaticTimestamp
  include Visma::CreatedBy
  include Visma::CreatedScopes
  belongs_to :customer_order_copy, foreign_key: :OrderCopyNo, primary_key: :OrderCopyNo
  alias :order :customer_order_copy
  belongs_to :article, foreign_key: :ArticleNo

  has_one :customer, through: :customer_order_copy
end
