class Visma::CustomerDeliveryAddress < Visma::Base
  self.table_name += 'CustomerDeliveryAddresses'
  self.primary_key = :DeliveryAddressNo
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy

  belongs_to :customer, foreign_key: :CustomerNo
  scope :active, -> { joins(:customer).where(customer: { InActiveYesNo: 0 }) }

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
end
