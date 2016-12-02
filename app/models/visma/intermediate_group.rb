class Visma::IntermediateGroup < Visma::Base
  self.table_name += 'IntermediateGroup'
  self.primary_key = 'IntermediateGroupNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy
  enum InActiveYesNo: [:active, :inactive]
  default_scope { active }

  has_many :article,
           foreign_key: 'IntermediateGroupNo',
           primary_key: 'IntermediateGroupNo'
end
