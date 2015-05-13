class Visma::Employee < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "Employee"
  self.primary_key = "EmployeeNo"

  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :logon_user, primary_key: :UserNo, foreign_key: :UserNo
end
