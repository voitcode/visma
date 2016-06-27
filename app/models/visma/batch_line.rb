class Visma::BatchLine < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "BatchLine"
  self.primary_key = "UniqueID"

  belongs_to :batch, foreign_key: :BatchNo, class_name: Visma::BatchInformation
end
