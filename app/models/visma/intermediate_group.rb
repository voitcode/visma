class Visma::IntermediateGroup < Visma::Base
  self.table_name += 'IntermediateGroup'
  enum InActiveYesNo: [:active, :inactive]
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy

  has_many :article, foreign_key: 'IntermediateGroupNo', primary_key: 'IntermediateGroupNo'
end
