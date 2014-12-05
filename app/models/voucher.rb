class Visma::Voucher < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.Voucher"
end
