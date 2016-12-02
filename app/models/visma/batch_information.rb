class Visma::BatchInformation < Visma::Base
  self.table_name += 'BatchInformation'
  self.primary_key = 'BatchNo'

  has_many :batch_lines, foreign_key: :BatchNo
  alias lines batch_lines
end
