class Visma::StorageType < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.StorageType"
  
  belongs_to :article, foreign_key: :StorageTypeNo, primary_key: :StorageTypeNo
end
