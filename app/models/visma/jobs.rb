class Visma::Jobs < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "Jobs"
  self.primary_key = "JobId"

  has_many :job_messages, foreign_key: :JobId
  has_many :job_locks, foreign_key: :JobId
end
