class Visma::CustomerGroup < Visma::Base
  self.table_name += 'CustomerGroup'
  self.primary_key = 'CustomerGrpNo'
  enum InActiveYesNo: [:active, :inactive]
  default_scope { active }
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy

  has_many :customers, foreign_key: 'CustomerGrpNo'
end
