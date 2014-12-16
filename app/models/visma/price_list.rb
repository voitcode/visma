class Visma::PriceList < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "PriceList"
  self.primary_key = "PriceListNo"

  has_many :campaign_price_list, foreign_key: "PriceListNo"
  has_many :discount_agreements,
    foreign_key: "PriceListNo",
    class_name: Visma::DiscountAgreementCustomer

  default_scope { where(InActiveYesNo: 0) }
end
