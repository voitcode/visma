class Visma::MainGroup < Visma::Base
  self.table_name += 'MainGroup'
  self.primary_key = 'MainGroupNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy
  enum InActiveYesNo: [:active, :inactive]
  default_scope { active }

  has_many :article, foreign_key: 'MainGroupNo', primary_key: 'MainGroupNo'
end
