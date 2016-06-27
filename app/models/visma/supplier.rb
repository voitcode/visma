class Visma::Supplier < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "Supplier"
  self.primary_key = "SupplierNo"
  enum :InActiveYesNo => [ :active, :inactive ]

  has_many :transactions, foreign_key: :SupplierNo, class_name: Visma::GLAccountTransaction
end
