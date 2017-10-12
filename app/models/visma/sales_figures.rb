module Visma
  # Sales statistics
  class SalesFigures < Visma::Base
    self.table_name += 'SalesFigures'
    self.primary_key = 'UniqueNo'

    include Visma::Timestamp
    include Visma::CreatedScopes
    include Visma::CreatedBy
    include Visma::ChangeBy
    belongs_to :chain, foreign_key: :ChainNo
    belongs_to :customer, foreign_key: :CustomerNo
    belongs_to :employee, foreign_key: :EmployeeNo
    belongs_to :article, foreign_key: :ArticleNo
  end
end
