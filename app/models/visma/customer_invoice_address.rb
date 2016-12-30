class Visma::CustomerInvoiceAddress < Visma::Base
  self.table_name += 'CustomerInvoiceAdresses'
  self.primary_key = 'InvoiceAdressNo'

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
