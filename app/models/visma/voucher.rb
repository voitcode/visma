class Visma::Voucher < Visma::Base
  self.table_name += 'Voucher'
  self.primary_key = 'VoucherID'

  has_many :transactions, foreign_key: :VoucherID, class_name: Visma::GLAccountTransaction
  belongs_to :voucher_group, foreign_key: :VoucherGroupNo
  belongs_to :voucher_type, foreign_key: :VoucherTypeNo
  has_one :voucher_information, foreign_key: :VoucherNo, primary_key: :VoucherNo
end
