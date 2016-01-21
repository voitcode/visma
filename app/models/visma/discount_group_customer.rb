class Visma::DiscountGroupCustomer < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "DiscountGroupCustomer"
  self.primary_key = "DiscountGrpCustNo"
  enum :InActiveYesNo => [ :active, :inactive ]
  default_scope { active }

  include Visma::Timestamp
  include Visma::ChangeBy

  has_many :customers, foreign_key: "DiscountGrpCustNo"

  has_many :campaign_price_list, foreign_key: "DiscountGrpCustNo"
  has_many :discount_agreement_customer, foreign_key: "DiscountGrpCustNo"
  alias :discount_agreements :discount_agreement_customer

  has_many :customer_order, foreign_key: "DiscountGrpCustNo"
  alias :orders :customer_order
  has_many :customer_order_copy, foreign_key: "DiscountGrpCustNo"
  alias :processed_orders :customer_order_copy

  def price_for(artno)
    discount_agreements.for(artno)
  end

  class << self
    def all_with_discount_agreements
      find(Visma::DiscountAgreementCustomer.uniq_ids(:DiscountGrpCustNo))
    end
  end
end
