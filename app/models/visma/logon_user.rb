class Visma::LogonUser < Visma::Base
  self.table_name += 'LogonUser'
  self.primary_key = 'UserNo'

  include Visma::Timestamp
  include Visma::ChangeBy

  has_one :employee, primary_key: :UserNo, foreign_key: :UserNo
end
