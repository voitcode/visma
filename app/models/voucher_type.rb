class Visma::VoucherType < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.VoucherType"
end
