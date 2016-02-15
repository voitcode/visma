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

  # The net price after discount
  def net_price
    (self.NetPrice - (self.NetPrice * self.DiscountI / 100)).round(2)
  end

  # The margin per unit
  def unit_margin
    (net_price - self.PurchasePrice).round(2)
  end

  # The net margin for this line
  def margin
    (unit_margin * self.Invoiced).round(2)
  end
end
