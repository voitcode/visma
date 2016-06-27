class Visma::VoucherType < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "VoucherType"
  self.primary_key = "VoucherTypeNo"
  enum :InActiveYesNo => [ :active, :inactive ]
end
