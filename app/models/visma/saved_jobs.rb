class Visma::SavedJobs < Visma::Base
  self.table_name += 'SavedJobs'
  # Check db/visma_schema.rb for primary key, delete and adjust as needed
  # self.primary_key = "SavedJobsNo"
  # self.primary_key = "UniqueNo"
end
