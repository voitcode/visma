class Visma::DiscountAgreementCustomer < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "DiscountAgreementCustomer"
  self.primary_key = "UniqueID"

  belongs_to :price_list, foreign_key: "PriceListNo"
  belongs_to :article, foreign_key: "ArticleNo"
  belongs_to :customer, foreign_key: "CustomerNo"

  belongs_to :discount_group_article, foreign_key: "DiscountGrpArtNo"
  belongs_to :discount_group_customer, foreign_key: "DiscountGrpCustNo"

  default_scope { where("StartDate <= ? AND StopDate >= ?", Date.today, Date.today) }

  def price
    p = self.AgreedPrice
    if discount > 0
      p = p - p * discount / 100
    end
    return p.round(2)
  end

  def discount
    self.DiscountI
  end

  class << self
    def for(artno)
      where(ArticleNo: artno.to_s).first rescue nil
    end
  end
end
