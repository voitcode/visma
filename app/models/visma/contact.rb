class Visma::Contact < Visma::Base
  self.table_name += 'Contact'
  self.primary_key = 'ContactNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy

  enum InActiveYesNo: [:active, :inactive]

  belongs_to :customer, foreign_key: :CustomerNo
end
