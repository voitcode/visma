class Visma::Customer < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "Customer"
  self.primary_key = "CustomerNo"

  has_many :customer_order, foreign_key: :CustomerNo

  has_many :edi_transactions, foreign_key: "PartyID", class_name: Visma::EDITransaction

  has_one :customer_delivery_addresses, foreign_key: :DeliveryAddressNo, primary_key: :DeliveryAddressNo
  has_one :invoice_address, foreign_key: :InvoiceAdressNo, primary_key: :InvoiceAdressNo, class_name: Visma::CustomerInvoiceAdresses

  has_one :invoice_contact, foreign_key: :ContactNo, primary_key: :ContactNoInvoice, class_name: Visma::Contact

  belongs_to :chain, foreign_key: :ChainNo, primary_key: :CustomerNo, class_name: Visma::Customer

  # Price list, discount group and such
  belongs_to :price_list, foreign_key: "PriceListNo"
  belongs_to :discount_group, foreign_key: "DiscountGrpCustNo", class_name: DiscountGroupCustomer
  has_many :discount_agreements, through: :discount_group
  has_many :campaign_price_list, foreign_key: "CustomerNo"


  has_one :customer_sum, foreign_key: "CustomerNo"

  # Isonor - Isomat custom table relationships
  has_one :z_usr_ruter_pr_kunde, foreign_key: "ZUsrCustomerNo"
  has_one :z_usr_ruter, through: :z_usr_ruter_pr_kunde

  # Return the correct price for a given article
  def prices_for(artno)
    raise TypeError, "price_for only takes a Fixnum" if artno.class != Fixnum
    prices = {}

    # If there is a discount group price
    if !self.DiscountGrpCustNo.blank?
      prices["discount_group"] = discount_agreements.where(ArticleNo: artno.to_s).AgreedPrice rescue nil
    end

    prices["price"] = Visma::Article.find(artno.to_s).Price1

    prices
  end

  # The current invoice address.
  # Based on wether the Chain or the Customer is getting the bill
  def current_invoice_address
    return invoice_address if chain.blank?
    return chain.invoice_address if self.TypeOfChain == 1
    return invoice_address
  end

  def address
    [self.Address1, self.Address2, "#{self.PostCode} #{self.PostOffice}"].join(", ")
  end

  def active_list
    where ["LastUpdate > ?", Date.new(Time.now.year - 1)]
  end

  # Find ICA stores by postcode
  def self.ica(postcode)
    where(PostCode: postcode.to_s).where("Name like '%rimi%' or Name like '%matkrok%' or Name like '%ica%'").all
  end
end
