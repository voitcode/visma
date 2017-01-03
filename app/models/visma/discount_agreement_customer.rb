# This model is the contract stating the price agreements
class Visma::DiscountAgreementCustomer < Visma::Base
  self.table_name += 'DiscountAgreementCustomer'
  self.primary_key = 'UniqueID'

  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :price_list, foreign_key: 'PriceListNo'
  belongs_to :article, foreign_key: 'ArticleNo'
  belongs_to :customer, foreign_key: 'CustomerNo'

  belongs_to :discount_group_article, foreign_key: 'DiscountGrpArtNo'
  belongs_to :discount_group_customer, foreign_key: 'DiscountGrpCustNo'

  scope :active, lambda {
    where('StartDate <= ? AND StopDate >= ?',
          Date.today.strftime('%Y-%m-%d %H:%M:%S'),
          Date.today.strftime('%Y-%m-%d %H:%M:%S'))
  }
  scope :inactive, lambda {
    where.not('StartDate <= ? AND StopDate >= ?',
              Date.today.strftime('%Y-%m-%d %H:%M:%S'),
              Date.today.strftime('%Y-%m-%d %H:%M:%S'))
  }

  # The agreed price deviates from the article price
  scope :deviant, lambda {
    joins(:article)
      .where('DiscountAgreementCustomer.AgreedPrice NOT IN (Article.Price1, 0)')
  }

  # Look up all DiscountAgreementCustomer available to given Customer
  scope :for_customer, lambda { |customer|
    where("CustomerNo = '#{customer.CustomerNo}'
        OR DiscountGrpCustNo = '#{customer.DiscountGrpCustNo}'
        OR PriceListNo = '#{customer.PriceListNo}'")
  }

  # This discount is currently active
  def active?
    self.StartDate <= Date.today && self.StopDate >= Date.today
  end

  def agreed_price
    self.AgreedPrice.zero? ? article.price : self.AgreedPrice
  end

  # Obviously, the discount can be more than this with three fields:
  # DiscountI DiscountII DiscountIII
  def discount
    self.DiscountI
  end

  # Obviously, the discount can be more than this with three fields:
  # DiscountI DiscountII DiscountIII
  def discount_factor
    (self.DiscountI / 100.0).round(4)
  end

  # Obviously, the discount can be more than this with three fields:
  # DiscountI DiscountII DiscountIII
  def discount_amount
    agreed_price * discount_factor
  end

  def price
    (agreed_price - discount_amount).round(2)
  end

  def price_source
    self.AgreedPrice == 0 ? 'Artikkelpris' : to_s
  end

  def discount_source
    discount == 0 ? nil : to_s
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
    case recipient.class.name
    when 'Visma::Customer'
      'Kunderabatt'
    when 'Visma::DiscountGroupCustomer'
      'Kunderabattgruppe'
    when 'Visma::DiscountGroupArticle'
      'Artikkelrabattgruppe'
    when 'Visma::PriceList'
      'Prisliste'
    end
  end

  def to_s
    "#{category} #{recipient.id}"
  end

  class << self
    def uniq_ids(field)
      active.where("#{field} != 0").select(field).uniq.map { |a| a[field] }
    end

    # Find discounts for a given ArticleNo
    def for(artno)
      where(ArticleNo: artno.to_s).first
    rescue
      nil
    end
    alias price_for for

    # Find discounts for a given date
    def at(date, artno)
      where(ArticleNo: artno.to_s).where('StartDate <= ? AND StopDate >= ?', date.to_date, date.to_date)
    end
  end
end
