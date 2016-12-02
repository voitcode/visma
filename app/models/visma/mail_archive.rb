class Visma::MailArchive < Visma::Base
  self.table_name += 'MailArchive'
  self.primary_key = 'Id'
  include Visma::Timestamp
  include Visma::ChangeBy
  include Visma::CreatedScopes
end
