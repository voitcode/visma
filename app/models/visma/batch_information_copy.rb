class Visma::BatchInformationCopy < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "BatchInformationCopy"
  self.primary_key = "BatchCopyNo"

  has_many :batch_line_copies, foreign_key: :BatchCopyNo
  alias :lines :batch_line_copies
end
