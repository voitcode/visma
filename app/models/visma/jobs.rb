class Visma::Jobs < Visma::Base
  self.table_name += 'Jobs'
  self.primary_key = 'JobId'

  has_many :job_messages, foreign_key: :JobId
  has_many :job_locks, foreign_key: :JobId
end
