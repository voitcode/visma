class Visma::Unit < Visma::Base
  self.table_name += 'Units'
  self.primary_key = 'UnitNo'

  has_many :articles, primary_key: :UnitNo, foreign_key: :UnitNo
end
