class Visma::CustomerProfile < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.CustomerProfile"
end
