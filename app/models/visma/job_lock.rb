class Visma::JobLock < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "JobLock"
  self.primary_key = "SeqNo"

  belongs_to :job, foreign_key: :JobId
end
