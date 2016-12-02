class Visma::SubGroup < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "SubGroup"
  self.primary_key = "SubGroupNo"
  enum :InActiveYesNo => [ :active, :inactive ]

  has_many :article, foreign_key: "SubGroupNo", primary_key: "SubGroupNo"
end
