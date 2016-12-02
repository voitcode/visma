class Visma::BatchLineCopy < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "BatchLineCopy"
  self.primary_key = "UniqueID"

  belongs_to :batch, foreign_key: :BatchCopyNo, class_name: Visma::BatchInformationCopy
end
