class Visma::Supplier < Visma::Base
  self.table_name += 'Supplier'
  self.primary_key = 'SupplierNo'
  enum InActiveYesNo: [:active, :inactive]

  has_many :transactions, foreign_key: :SupplierNo, class_name: 'Visma::GLAccountTransaction'
end
