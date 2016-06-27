class Visma::VoucherInformation < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "VoucherInformation"
  self.primary_key = "VoucherNo"
  belongs_to :voucher_group, foreign_key: :VoucherGroupNo
end
