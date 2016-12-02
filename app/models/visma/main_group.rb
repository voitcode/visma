class Visma::MainGroup < Visma::Base
  self.table_name += 'MainGroup'
  self.primary_key = 'MainGroupNo'
  enum InActiveYesNo: [:active, :inactive]

  has_many :article, foreign_key: 'MainGroupNo', primary_key: 'MainGroupNo'
end
