class Visma::CustomerInvoiceAddress < Visma::Address
  self.table_name += 'CustomerInvoiceAdresses'
  self.primary_key = 'InvoiceAdressNo'

  belongs_to :customer, foreign_key: :InvoiceAdressCustomerNo

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

  def unique_address_per_customer
    return true if customer.nil?
    return true unless customer.invoice_addresses.to_a.include?(self)
    errors.add(:InvoiceAdress1, 'Not Unique')
    false
  end
end
