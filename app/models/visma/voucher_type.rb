class Visma::VoucherType < Visma::Base
  self.table_name += 'VoucherType'
  self.primary_key = 'VoucherTypeNo'
  enum InActiveYesNo: [:active, :inactive]
end
