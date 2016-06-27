class Visma::GLAccount < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "GLAccount"
  self.primary_key = "GLAccountNo"
  enum :InActiveYesNo => [ :active, :inactive ]

  has_many :transactions, foreign_key: :GLAccountNo, class_name: Visma::GLAccountTransaction
end
