class Visma::DiscountAgreementCustomer < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "DiscountAgreementCustomer"
  self.primary_key = "UniqueID"

  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :price_list, foreign_key: "PriceListNo"
  belongs_to :article, foreign_key: "ArticleNo"
  belongs_to :customer, foreign_key: "CustomerNo"

  belongs_to :discount_group_article, foreign_key: "DiscountGrpArtNo"
  belongs_to :discount_group_customer, foreign_key: "DiscountGrpCustNo"

  scope :active, -> { where("StartDate <= ? AND StopDate >= ?", Date.today, Date.today) }
  scope :inactive, -> { where.not("StartDate <= ? AND StopDate >= ?", Date.today, Date.today) }

  # The agreed price deviates from the article price
  scope :deviant, -> { joins(:article).where("DiscountAgreementCustomer.AgreedPrice NOT IN (Article.Price1, 0)") }

  # This discount is currently active
  def active?
    self.StartDate <= Date.today && self.StopDate >= Date.today
  end

  def agreed_price
    self.AgreedPrice == 0 ? article.price : self.AgreedPrice
  end

  def discount_factor
    (self.DiscountI / 100.0).round(4)
  end

  def discount_amount
    agreed_price * discount_factor
  end

  def price
    (agreed_price - discount_amount).round(2)
  end

  def price_source
    self.AgreedPrice == 0 ? "Article" : "Agreement"
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
    def uniq_ids(field)
      active.where("#{field} != 0").select(field).uniq.map {|a| a[field] }
    end

    def for(artno)
      active.where(ArticleNo: artno.to_s).first rescue nil
    end
    alias price_for for
  end
end
