class Visma::JobMessage < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "JobMessage"
  self.primary_key = "SeqNo"
end
