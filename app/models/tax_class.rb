class Visma::TaxClass < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.TaxClass"
end
