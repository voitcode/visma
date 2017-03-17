class Visma::CustomerType < Visma::Base
  self.table_name += 'CustomerType'
  self.primary_key = 'CustomerTypeNo'
  enum LockedYesNo: [:active, :inactive]
  default_scope { active }
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy

  has_many :customers, foreign_key: 'CustomerTypeNo'
end
