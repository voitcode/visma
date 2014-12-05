class Visma::MainGroup < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.MainGroup"

  has_many :article, foreign_key: "MainGroupNo", primary_key: "MainGroupNo"
end
