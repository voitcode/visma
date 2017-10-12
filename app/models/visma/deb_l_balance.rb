module Visma
  # Debitor balance lines
  class DebLBalance < Visma::Base
    self.table_name += 'DebLBalance'
    self.primary_key = 'UniqueNo'
    include Visma::Timestamp
    include Visma::CreatedScopes
    include Visma::CreatedBy
    include Visma::ChangeBy
    belongs_to :customer, foreign_key: :CustomerNo
    belongs_to :employee, foreign_key: :EmployeeNo
  end
end
