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

  has_one :customer_sum, foreign_key: "CustomerNo"

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
