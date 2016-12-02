class Visma::SubGroup < Visma::Base
  self.table_name += 'SubGroup'
  self.primary_key = 'SubGroupNo'
  enum InActiveYesNo: [:active, :inactive]

  has_many :article, foreign_key: 'SubGroupNo', primary_key: 'SubGroupNo'
end
