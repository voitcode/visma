class Visma::Unit < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "Units"
  self.primary_key = "UnitNo"

  has_many :articles, primary_key: :UnitNo, foreign_key: :UnitNo
end
