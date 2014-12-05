class Visma::CustomerType < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.CustomerType"
end
