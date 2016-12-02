class Visma::GLAccount < Visma::Base
  self.table_name += 'GLAccount'
  self.primary_key = 'GLAccountNo'
  enum InActiveYesNo: [:active, :inactive]

  has_many :transactions, foreign_key: :GLAccountNo, class_name: Visma::GLAccountTransaction
end
