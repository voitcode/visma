class Visma::CampaignPriceList < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CampaignPriceList"
  #self.primary_key = NOT AVAILABLE

  belongs_to :customer, foreign_key: "CustomerNo"
  belongs_to :chain, foreign_key: "ChainNo", class_name: Visma::Customer
end
