class Visma::InvoiceJournal < Visma::Base
  self.table_name += 'InvoiceJournal'
  self.primary_key = 'InvoiceNo'

  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :employee, foreign_key: :EmployeeNo
  belongs_to :tax_class, foreign_key: :TaxClassNo

  has_one :customer_order_copy, foreign_key: :InvoiceNo
end
