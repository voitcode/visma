class Visma::SubGroup < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.SubGroup"

  has_many :article, foreign_key: "SubGroupNo", primary_key: "SubGroupNo"
end
