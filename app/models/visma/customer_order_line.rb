class Visma::CustomerOrderLine < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerOrderLine"
  self.primary_key = :UniqueID

  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :customer_order, foreign_key: :OrderNo, primary_key: :OrderNo
  alias :order :customer_order
  belongs_to :article, foreign_key: :ArticleNo

  has_one :customer, through: :customer_order
end
