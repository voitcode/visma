class Visma::Employee < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.Employee"
  self.primary_key = "EmployeeNo"

  belongs_to :logon_user, primary_key: :UserNo, foreign_key: :UserNo
end
