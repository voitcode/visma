class Visma::CredLTransaction < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CredLTransaction"
  self.primary_key = "UniqueNo"
  belongs_to :batch, foreign_key: :BatchNo, class_name: Visma::BatchInformationCopy
end
