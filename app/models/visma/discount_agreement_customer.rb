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

  class << self
    def price_for(artno)
      raise TypeError, "price_for only takes a Fixnum" if artno.class != Fixnum

      where(ArticleNo: artno.to_s).first.AgreedPrice rescue 0
    end
  end
end
