class Visma::IntermediateGroup < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "IntermediateGroup"
  self.primary_key = "IntermediateGroupNo"
  enum :InActiveYesNo => [ :active, :inactive ]

  has_many :article, foreign_key: "IntermediateGroupNo", primary_key: "IntermediateGroupNo"
end
