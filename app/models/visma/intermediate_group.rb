class Visma::IntermediateGroup < Visma::Base
  self.table_name += 'IntermediateGroup'
  enum InActiveYesNo: [:active, :inactive]

  has_many :article, foreign_key: 'IntermediateGroupNo', primary_key: 'IntermediateGroupNo'
end
