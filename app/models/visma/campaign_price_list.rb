# TODO: map out the relationship between CampaignPriceList and DiscountAgreementCustomer
class Visma::CampaignPriceList < Visma::Base
  self.table_name += 'CampaignPriceList'
  self.primary_key = 'SeqNo'

  belongs_to :customer, foreign_key: 'CustomerNo'
  belongs_to :chain, foreign_key: 'ChainNo', class_name: 'Visma::Customer'
  belongs_to :discount_group_customer, foreign_key: 'DiscountGrpCustNo'
  belongs_to :price_list, foreign_key: 'PriceListNo', class_name: 'Visma::PriceList'

  default_scope { where('FromDate <= ? AND ToDate >= ?', Date.today, Date.today) }
end
