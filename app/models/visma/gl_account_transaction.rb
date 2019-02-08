module Visma
  # General Ledger transactions
  class GLAccountTransaction < Visma::Base
    self.table_name += 'GLAccountTransaction'
    self.primary_key = 'UniqueNo'

    include Visma::Timestamp
    include Visma::CreatedScopes
    include Visma::CreatedBy
    include Visma::ChangeBy

    belongs_to :account, foreign_key: :GLAccountNo, class_name: 'Visma::GLAccount'
    belongs_to :supplier, foreign_key: :SupplierNo
    belongs_to :customer, foreign_key: :CustomerNo
    belongs_to :voucher, foreign_key: :VoucherID
    belongs_to :voucher_type, foreign_key: :VoucherTypeNo
    belongs_to :employee, foreign_key: :EmployeeNo

    belongs_to :batch, foreign_key: :BatchNo, class_name: 'Visma::BatchInformationCopy'

    scope :credit, -> { where('Amount >= 0') }
    scope :debit, -> { where('Amount < 0') }
    scope :supplier, -> { where.not(SupplierNo: 0) }
    scope :customer, -> { where.not(CustomerNo: 0) }
    scope :sum_amount_per_weekday, lambda {
      grouping = "convert(varchar, (DATEPART(dw, VoucherDate) - 1)) + ' ' + DATENAME(weekday, VoucherDate)" # weekday name
      select("SUM(Amount) as Amount, #{grouping} as Description")
        .group(grouping)
    }
    scope :sum_amount_per_date, lambda {
      grouping = 'convert(varchar, VoucherDate, 104)' # date
      select("#{grouping} as Description, EmployeeNo, CreatedBy, SUM(Amount) as Amount")
        .group(grouping, :EmployeeNo, :CreatedBy)
    }
  end
end
