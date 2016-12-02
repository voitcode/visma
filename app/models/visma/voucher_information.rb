class Visma::VoucherInformation < Visma::Base
  self.table_name += 'VoucherInformation'
  self.primary_key = 'VoucherNo'
  belongs_to :voucher_group, foreign_key: :VoucherGroupNo
end
