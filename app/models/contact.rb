class Visma::Contact < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.Contact"
  self.primary_key = "ContactNo"
end
