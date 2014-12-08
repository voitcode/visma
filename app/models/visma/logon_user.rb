class Visma::LogonUser < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "LogonUser"
  self.primary_key = "UserNo"

  has_one :employee, primary_key: :UserNo, foreign_key: :UserNo
end
