class Visma::EDIForms < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.EDIForms"
  self.primary_key = "EDIFormNo"
end
