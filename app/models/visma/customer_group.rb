class Visma::CustomerGroup < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerGroup"
  self.primary_key = "CustomerGrpNo"
  enum :InActiveYesNo => [ :active, :inactive ]
end
