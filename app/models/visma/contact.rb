class Visma::Contact < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "Contact"
  self.primary_key = "ContactNo"
  enum :InActiveYesNo => [ :active, :inactive ]
end
