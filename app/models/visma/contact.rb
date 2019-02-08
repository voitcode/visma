# Customer contact persons
class Visma::Contact < Visma::Base
  self.table_name += 'Contact'
  self.primary_key = 'ContactNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy
  include Visma::PrimaryKey

  enum InActiveYesNo: [:active, :inactive]

  belongs_to :customer, foreign_key: :CustomerNo
  has_many :customers_as_invoice_contact,
           foreign_key: :ContactNoInvoice,
           class_name: 'Visma::Customer'
  has_many :customers_as_delivery_contact,
           foreign_key: :ContactNoDelivery,
           class_name: 'Visma::Customer'

  validates :ContactNo, :EmailAddress, :MobileTelephone, presence: true

  scope :customer, -> { where.not(CustomerNo: 0).where.not(CustomerNo: nil) }
  scope :supplier, -> { where.not(SupplierNo: 0).where.not(SupplierNo: nil) }
end
