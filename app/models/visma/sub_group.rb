class Visma::SubGroup < Visma::Base
  self.table_name += 'SubGroup'
  self.primary_key = 'SubGroupNo'
  enum InActiveYesNo: [:active, :inactive]
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy

  has_many :article, foreign_key: 'SubGroupNo', primary_key: 'SubGroupNo'
end
