class Visma::GLAccount < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.GLAccount"
end
