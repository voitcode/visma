class Visma::BatchLineCopy < Visma::Base
  self.table_name += 'BatchLineCopy'
  self.primary_key = 'UniqueID'

  belongs_to :batch, foreign_key: :BatchCopyNo, class_name: Visma::BatchInformationCopy
end
