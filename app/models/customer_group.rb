class Visma::CustomerGroup < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.CustomerGroup"
  self.primary_key = "CustomerGrpNo"
end
