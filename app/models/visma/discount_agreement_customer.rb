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

  # Return the discounted party
  def recipient
    return customer if self.CustomerNo != 0
    return discount_group_customer if self.DiscountGrpCustNo != 0
    return discount_group_article if self.DiscountGrpArtNo != 0
    price_list
  end

  # What kind of agreement is this?
  def category
    recipient.class
  end

  def to_s
    recipient.Name + " (#{category})"
  end

  class << self
    def for(artno)
      where(ArticleNo: artno.to_s).first rescue nil
    end
  end
end
