class Visma::BatchInformation < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "BatchInformation"
  self.primary_key = "BatchNo"

  has_many :batch_lines, foreign_key: :BatchNo
  alias :lines :batch_lines
end
