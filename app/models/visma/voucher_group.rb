class Visma::VoucherGroup < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "VoucherGroup"
  self.primary_key = "VoucherGroupNo"
end
