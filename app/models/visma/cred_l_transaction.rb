class Visma::CredLTransaction < Visma::Base
  self.table_name += 'CredLTransaction'
  self.primary_key = 'UniqueNo'
  belongs_to :batch, foreign_key: :BatchNo, class_name: Visma::BatchInformationCopy
end
