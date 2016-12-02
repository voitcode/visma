class Visma::JobLock < Visma::Base
  self.table_name += 'JobLock'
  self.primary_key = 'SeqNo'

  belongs_to :job, foreign_key: :JobId
end
