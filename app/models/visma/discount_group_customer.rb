class Visma::DiscountGroupCustomer < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "DiscountGroupCustomer"
  self.primary_key = "DiscountGrpCustNo"

  has_many :campaign_price_list, foreign_key: "DiscountGrpCustNo"

  has_many :discount_agreements,
    foreign_key: "DiscountGrpCustNo",
    class_name: Visma::DiscountAgreementCustomer

  default_scope { where(InActiveYesNo: 0) }
end
