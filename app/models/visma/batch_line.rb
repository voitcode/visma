class Visma::BatchLine < Visma::Base
  self.table_name += 'BatchLine'
  self.primary_key = 'UniqueID'

  belongs_to :batch, foreign_key: :BatchNo, class_name: Visma::BatchInformation
end
