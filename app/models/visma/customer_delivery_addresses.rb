class Visma::CustomerDeliveryAddresses < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerDeliveryAddresses"
  self.primary_key = :DeliveryAddressNo

  # Norwegian formatting
  def to_s
    lines = [
      name, line1, line2, line3,
      "#{zip} #{city}"
    ].collect {|ln| ln.blank? ? nil : ln }.compact
    lines.join("\n")
  end

  # Common names for different address models
  def name; self.DeliveryName; end
  def line1; self.DeliveryAddress1; end
  def line2; self.DeliveryAddress2; end
  def line3; self.DeliveryAddress3; end
  def zip; self.DeliveryPostCode; end
  def city; self.DeliveryPostOffice; end
end
