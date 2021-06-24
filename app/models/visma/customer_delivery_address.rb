class Visma::CustomerDeliveryAddress < Visma::Address
  self.table_name += 'CustomerDeliveryAddresses'
  self.primary_key = 'DeliveryAddressNo'

  belongs_to :customer, foreign_key: :CustomerNo

  scope :primary, -> { joins(:customer).where('Customer.DeliveryAddressNo = CustomerDeliveryAddresses.DeliveryAddressNo') }

  # Is this address the primary delivery address for the customer?
  def primary
    customer.DeliveryAddressNo == id
  end

  # Change the Customer's primary delivery address to this one
  # Accepts any truthy value, does nothing on negative
  def primary=(set_primary)
    return unless set_primary
    customer.update(DeliveryAddressNo: id)
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
    addresses = Visma::CustomerDeliveryAddress
                .where(CustomerNo: self.CustomerNo)
                .to_a - [self]
    errors.add(:DeliveryAddress1, :is_already_in_use) if
      addresses.include? self
  end

  # Defines which common address attributes goes where
  def attribute_aliases
    {
      name:  :DeliveryName,
      line1: :DeliveryAddress1,
      line2: :DeliveryAddress2,
      line3: :DeliveryAddress3,
      zip:   :DeliveryPostCode,
      city:  :DeliveryPostOffice,
      gln:   :DeliveryEANLocationNo
    }
  end

  def type
    'KundeLeveringsAdresse'
  end
end
