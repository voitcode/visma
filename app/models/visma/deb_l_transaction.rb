module Visma
  # Debitor transactions
  class DebLTransaction < Visma::Base
    self.table_name += 'DebLTransaction'
    self.primary_key = 'UniqueNo'
    belongs_to :batch,
               foreign_key: :BatchNo,
               class_name: 'Visma::BatchInformationCopy'

    include Visma::Timestamp
    include Visma::CreatedScopes
    include Visma::CreatedBy
    include Visma::ChangeBy
    belongs_to :customer, foreign_key: :CustomerNo
    belongs_to :employee, foreign_key: :EmployeeNo
  end
end
