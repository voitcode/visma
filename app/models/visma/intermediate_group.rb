class Visma::IntermediateGroup < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.IntermediateGroup"

  has_many :article, foreign_key: "IntermediateGroupNo", primary_key: "IntermediateGroupNo"
end
