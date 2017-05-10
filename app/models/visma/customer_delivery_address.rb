class Visma::CustomerDeliveryAddress < Visma::Address
  self.table_name += 'CustomerDeliveryAddresses'
  self.primary_key = :DeliveryAddressNo

  belongs_to :customer, foreign_key: :CustomerNo

  # Is this address the primary delivery address for the customer?
  def primary
    customer.DeliveryAddressNo == id
  end

  # Change the Customer's primary delivery address to this one
  # Accepts any truthy value, does nothing on negative
  def primary=(bool)
    return unless bool
    customer.DeliveryAddressNo = id
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
    self.DeliveryName
  end

  def line1
    self.DeliveryAddress1
  end

  def line2
    self.DeliveryAddress2
  end

  def line3
    self.DeliveryAddress3
  end

  def zip
    self.DeliveryPostCode
  end

  def city
    self.DeliveryPostOffice
  end

  def unique_address_per_customer
    addresses = Visma::CustomerDeliveryAddress
                .where(CustomerNo: self.CustomerNo)
                .to_a - [self]
    errors.add(:DeliveryAddress1, :is_already_in_use) if
      addresses.include? self
  end
end
