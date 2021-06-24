class Visma::CustomerInvoiceAddress < Visma::Address
  self.table_name += 'CustomerInvoiceAdresses'
  self.primary_key = 'InvoiceAdressNo'

  belongs_to :customer, foreign_key: :InvoiceAdressCustomerNo

  scope :primary, -> { joins(:customer).where('Customer.InvoiceAdressNo = CustomerInvoiceAdresses.InvoiceAdressNo') }

  # Is this address the primary invoice address for the customer?
  def primary
    customer.InvoiceAdressNo == id
  end

  # Change the Customer's primary invoice address to this one
  # Accepts any truthy value, does nothing on negative
  def primary=(set_primary)
    return unless set_primary
    customer.update(InvoiceAdressNo: id)
  end

  # Norwegian formatting
  def to_s
    lines = [
      name, line1, line2, line3,
      "#{zip} #{city}"
    ].collect { |ln| ln.blank? ? nil : ln }.compact
    lines.join("\n")
  end

  def unique_address_per_customer
    addresses = Visma::CustomerInvoiceAddress
                .where(InvoiceAdressCustomerNo: self.InvoiceAdressCustomerNo)
                .to_a - [self]
    errors.add(:InvoiceAdress1, :is_already_in_use) if
      addresses.include? self
  end

  # Defines which common address attributes goes where
  def attribute_aliases
    {
      name:  :InvoiceAdressName,
      line1: :InvoiceAdress1,
      line2: :InvoiceAdress2,
      line3: :InvoiceAdress3,
      zip:   :InvoiceAdressPostCode,
      city:  :InvoiceAdressPostoffice,
      gln:   :InvoiceEANLocationNo
    }
  end

  def type
    'KundeFakturaAdresse'
  end
end
