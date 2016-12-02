class Visma::MailArchiveAttachemts < Visma::Base
  self.table_name += 'MailArchiveAttachemts'
  self.primary_key = 'Id'
  belongs_to :mail_archive, foreign_key: 'MailArchieveId'
  include Visma::Timestamp
  include Visma::ChangeBy
  include Visma::CreatedScopes
end
