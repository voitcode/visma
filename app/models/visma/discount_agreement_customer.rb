class Visma::DiscountAgreementCustomer < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "DiscountAgreementCustomer"
  self.primary_key = "UniqueID"

  self.use_activerecord_cache = true
  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :price_list, foreign_key: "PriceListNo"
  belongs_to :article, foreign_key: "ArticleNo"
  belongs_to :customer, foreign_key: "CustomerNo"

  belongs_to :discount_group_article, foreign_key: "DiscountGrpArtNo"
  belongs_to :discount_group_customer, foreign_key: "DiscountGrpCustNo"

  scope :active, -> { where("StartDate <= ? AND StopDate >= ?", Date.today, Date.today) }

  def agreed_price
    self.AgreedPrice == 0 ? article.price : self.AgreedPrice
  end

  def price
    (agreed_price - discount_amount).round(2)
  end

  def discount_amount
    agreed_price * self.DiscountI / 100
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
