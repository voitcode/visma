class Visma::CampaignPriceList < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CampaignPriceList"
  self.primary_key = "SeqNo"

  belongs_to :customer, foreign_key: "CustomerNo"
  belongs_to :chain, foreign_key: "ChainNo", class_name: Visma::Customer
  belongs_to :discount_group_customer, foreign_key: "DiscountGrpCustNo"
  belongs_to :price_list, foreign_key: "PriceListNo"
end
