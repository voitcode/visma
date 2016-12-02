class Visma::SubGroup < Visma::Base
  self.table_name += 'SubGroup'
  self.primary_key = 'SubGroupNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy
  enum InActiveYesNo: [:active, :inactive]
  default_scope { active }

  has_many :article, foreign_key: 'SubGroupNo', primary_key: 'SubGroupNo'
end
