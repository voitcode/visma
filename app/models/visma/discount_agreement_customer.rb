# frozen_string_literal: true

# A DiscountAgreementCustomer describes the gross price, discount
# and net price that was agreed with a given party for an Article.
#
# The party is a Customer, a DiscountGroupCustomer or a PriceList
class Visma::DiscountAgreementCustomer < Visma::Base
  self.table_name += 'DiscountAgreementCustomer'
  self.primary_key = 'UniqueID'

  include Visma::Timestamp
  include Visma::ChangeBy
  include Visma::CreatedScopes
  include Visma::SequenceNumber

  belongs_to :article, foreign_key: :ArticleNo

  belongs_to :customer,
             foreign_key: :CustomerNo, optional: true
  belongs_to :price_list,
             foreign_key: :PriceListNo, optional: true
  belongs_to :discount_group_article,
             foreign_key: :DiscountGrpArtNo, optional: true
  belongs_to :discount_group_customer,
             foreign_key: :DiscountGrpCustNo, optional: true

  scope :active, -> { at(Date.today) }
  scope :inactive, lambda {
    where.not('? BETWEEN StartDate AND StopDate', Date.today.to_date)
  }
  scope :future, lambda {
    where('StartDate > ?', Date.today.to_date)
  }

  enum DiscountType: [
       1 => :customer_discount,
       3 => :group_discount,
       10 => :pricelist_discount
  ]

  # The agreed price deviates from the article price
  scope :deviant, lambda {
    joins(:article)
      .where('DiscountAgreementCustomer.AgreedPrice NOT IN (Article.Price1, 0)')
  }

  # Look up all DiscountAgreementCustomer available to given Customer
  scope :for_customer, lambda { |customer|
    where(customer.discount_sources_sql_str, *customer.discount_ids)
  }

  # Find discounts for a given ArticleNo
  scope :for, ->(article_number) { where(ArticleNo: article_number.to_s) }

  # Find discounts that are active at a given date
  scope :at, lambda { |date|
    where('? BETWEEN StartDate AND StopDate', date.to_date)
  }

  after_initialize :set_default_values, if: :new_record?

  validates_with Visma::DiscountPartyValidator
  validates_uniqueness_of :SeqNo, scope: %I[
    DiscountType CustomerNo DiscountGrpCustNo PriceListNo
  ]

  # This discount is currently active
  def active?
    Date.today.between? self.StartDate, self.StopDate
  end

  def agreed_price
    self.AgreedPrice.zero? ? article.price : self.AgreedPrice
  end

  def agreed_price=(price)
    self.AgreedPrice = price
  end

  # TODO: Obviously, the discount can be more than this with three fields:
  # DiscountI DiscountII DiscountIII
  def discount
    self.DiscountI
  end

  # TODO: Obviously, the discount can be more than this with three fields:
  # DiscountI DiscountII DiscountIII
  def discount_factor
    (self.DiscountI / 100.0).round(4)
  end

  # TODO: Obviously, the discount can be more than this with three fields:
  # DiscountI DiscountII DiscountIII
  def discount_amount
    agreed_price * discount_factor
  end

  def price
    (agreed_price - discount_amount).round(2)
  end

  def price_source
    self.AgreedPrice.zero? ? 'Artikkelpris' : to_s
  end

  def explained_price
    [to_s, price]
  end

  def discount_source
    discount.zero? ? nil : to_s
  end

  # Return the discounted party
  def discounted_party
    return customer unless self.CustomerNo.to_i.zero?
    return discount_group_customer unless self.DiscountGrpCustNo.to_i.zero?
    return discount_group_article unless self.DiscountGrpArtNo.to_i.zero?

    price_list
  end

  # What kind of agreement is this?
  def category
    case discounted_party.class.name
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
    "#{category} #{discounted_party.id}"
  end

  def set_default_values
    self.AgreedPrice ||= 0.0
    self.BonusPercent ||= 0.0
    self.CurrencyNo ||= 0
    self.DiscountGrpArtNo ||= 0
    self.DiscountGrpCustNo ||= 0
    self.DiscountI ||= 0.0
    self.DiscountII ||= 0.0
    self.DiscountIII ||= 0.0
    self.DiscountType ||= 1
    self.FromQuantity ||= 0.0
    self.GrossPrice ||= 0.0
    self.IntermediateGroupNo ||= 0
    self.LoanPrice ||= 0.0
    self.MainGroupNo ||= 0
    self.Markup1 ||= 0.0
    self.PriceListNo ||= 0
    self.SubGroupNo ||= 0
    self.ToQuantity ||= 0.0
    self.UnitTypeNo ||= 0
    self.UtilityBits ||= "\x00\x00\x00\x00\x00\x00"
    self.ProjectNo ||= 0
    self.Priority ||= 0
    self.PriceLabeled ||= 0.0
    self.ZUsrPaaslagProsent ||= 0.0
    self.ZUsrPaaslagKroner ||= 0.0
    set_sequence
  end

  def siblings
    self.class.where(
      DiscountType: self.DiscountType,
      CustomerNo: self.CustomerNo,
      DiscountGrpCustNo: self.DiscountGrpCustNo,
      PriceListNo: self.PriceListNo
    )
  end

  class << self
    def uniq_ids(field)
      active.where("#{field} != 0").select(field).uniq.map { |a| a[field] }
    end
  end
end
