# The PriceList class gathers a group of DiscountAgreementCustomer
# to provide these to the Customers that belongs to the PriceList.
class Visma::PriceList < Visma::Base
  self.table_name += 'PriceList'
  self.primary_key = 'PriceListNo'
  enum InActiveYesNo: [:active, :inactive]
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy
  default_scope { active }

  has_many :customers, foreign_key: :PriceListNo

  has_many :campaign_price_list, foreign_key: :PriceListNo

  has_many :discount_agreement_customer, foreign_key: :PriceListNo
  alias discount_agreements discount_agreement_customer

  has_many :customer_order, foreign_key: :PriceListNo
  alias orders customer_order
  has_many :customer_order_copy, foreign_key: :PriceListNo
  alias processed_orders customer_order_copy

  has_many :customer_order_line, foreign_key: :PriceListNo
  alias order_lines customer_order_line
  has_many :customer_order_line_copy, foreign_key: :PriceListNo
  alias processed_order_lines customer_order_line_copy

  def price_for(artno)
    discount_agreements.for(artno)
  end

  class << self
    def all_with_discount_agreements
      find(Visma::DiscountAgreementCustomer.uniq_ids(:PriceListNo))
    end
  end
end
