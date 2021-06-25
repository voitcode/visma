class Visma::CustomerOrderLine < Visma::Base
  self.table_name += 'CustomerOrderLine'
  self.primary_key = :UniqueID

  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :customer_order, foreign_key: :OrderNo, primary_key: :OrderNo
  alias order customer_order
  belongs_to :article, foreign_key: :ArticleNo

  belongs_to :sub_group, foreign_key: :SubGroupNo
  belongs_to :main_group, foreign_key: :MainGroupNo

  has_one :customer, through: :customer_order

  # The NetPrice discount
  def net_price_discount
    self.NetPrice * self.DiscountI / 100
  end

  # The net price after discount
  def net_price_not_rounded
    self.NetPrice - net_price_discount
  end

  # The net price after discount, rounded to two decimals
  def net_price
    net_price_not_rounded.round(2)
  end

  # The net price plus VAT
  def net_price_including_vat
    net_price_not_rounded * vat_factor
  end

  # The VAT factor for price calculations
  def vat_factor
    1 + self.VATPer / 100
  end

  # The VAT amount on this order line
  def vat_amount
    (net_price_including_vat - net_price_not_rounded).round(2)
  end

  # The margin per unit
  def unit_margin
    (net_price - self.PurchasePrice).round(2)
  end

  # The net margin for this line
  def margin
    (unit_margin * self.PartDelivered).round(2)
  end

  class << self
    # Find order lines for given customer
    def for_customer_no(customer_number)
      joins(:customer).where(customer: { CustomerNo: customer_number })
    end
  end
end
