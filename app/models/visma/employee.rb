class Visma::Employee < Visma::Base
  self.table_name += 'Employee'
  self.primary_key = 'EmployeeNo'
  enum InActiveYesNo: [:active, :inactive]
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy

  belongs_to :logon_user, primary_key: :UserNo, foreign_key: :UserNo

  has_many :customers, foreign_key: :EmployeeNo
  has_many :customer_order_copy, through: :customers
  has_many :customer_order_line_copies, through: :customer_order_copy
  alias order_lines customer_order_line_copies
end
