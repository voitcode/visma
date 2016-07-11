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

  belongs_to :sub_group, foreign_key: :SubGroupNo
  belongs_to :main_group, foreign_key: :MainGroupNo

  has_one :customer, through: :customer_order_copy

  # The net price after discount
  def net_price
    (self.NetPrice - (self.NetPrice * self.DiscountI / 100)).round(2) rescue 0
  end

  # The margin per unit
  def unit_margin
    (net_price - self.PurchasePrice).round(2) rescue 0
  end

  # The net margin for this line
  def margin
    (unit_margin * self.Invoiced).round(2) rescue 0
  end

  class << self
    # Find order lines for given customer
    def for_customer_no(customer_number)
      joins(:customer).where(customer: {CustomerNo: customer_number})
    end
  end
end
