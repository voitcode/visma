class Visma::MainGroup < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "MainGroup"

  has_many :article, foreign_key: "MainGroupNo", primary_key: "MainGroupNo"
end
