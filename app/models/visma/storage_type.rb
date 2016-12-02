class Visma::StorageType < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "StorageType"
  self.primary_key = "StorageTypeNo"

  belongs_to :article, foreign_key: :StorageTypeNo, primary_key: :StorageTypeNo
end
