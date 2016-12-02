class Visma::BatchInformationCopy < Visma::Base
  self.table_name += 'BatchInformationCopy'
  self.primary_key = 'BatchCopyNo'

  has_many :batch_line_copies, foreign_key: :BatchCopyNo
  alias lines batch_line_copies
end
