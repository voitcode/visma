module Visma
  # Voucher
  class Voucher < Visma::Base
    self.table_name += 'Voucher'
    self.primary_key = 'VoucherID'

    include Visma::Timestamp
    include Visma::CreatedScopes
    include Visma::CreatedBy
    include Visma::ChangeBy
    belongs_to :customer, foreign_key: :CustomerNo
    belongs_to :employee, foreign_key: :EmployeeNo

    has_many :transactions, foreign_key: :VoucherID, class_name: 'Visma::GLAccountTransaction'
    belongs_to :voucher_group, foreign_key: :VoucherGroupNo
    belongs_to :voucher_type, foreign_key: :VoucherTypeNo
    has_one :voucher_information, foreign_key: :VoucherNo, primary_key: :VoucherNo
  end
end
