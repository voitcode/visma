class Visma::CustomerInvoiceAddress < Visma::Base
  self.table_name += 'CustomerInvoiceAdresses'
  self.primary_key = 'InvoiceAdressNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy
  include Visma::PrimaryKey

  belongs_to :customer, foreign_key: :InvoiceAdressCustomerNo
  scope :active, -> { joins(:customer).where(customer: { InActiveYesNo: 0 }) }

  # Is this address the primary invoice address for the customer?
  def primary
    customer.InvoiceAdressNo == id
  end

  # Change the Customer's primary invoice address to this one
  # Accepts any truthy value, does nothing on negative
  def primary=(bool)
    return unless bool
    customer.InvoiceAdressNo = id
    customer.save
  end

  # Norwegian formatting
  def to_s
    lines = [
      name, line1, line2, line3,
      "#{zip} #{city}"
    ].collect { |ln| ln.blank? ? nil : ln }.compact
    lines.join("\n")
  end

  # Common names for different address models
  def name
    self.InvoiceAdressName
  end

  def line1
    self.InvoiceAdress1
  end

  def line2
    self.InvoiceAdress2
  end

  def line3
    self.InvoiceAdress3
  end

  def zip
    self.InvoiceAdressPostCode
  end

  def city
    self.InvoiceAdressPostoffice
  end
end
