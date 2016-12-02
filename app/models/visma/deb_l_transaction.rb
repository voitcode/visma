class Visma::DebLTransaction < Visma::Base
  self.table_name += 'DebLTransaction'
  self.primary_key = 'UniqueNo'
  belongs_to :batch, foreign_key: :BatchNo, class_name: Visma::BatchInformationCopy
end
