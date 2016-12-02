class Visma::MailRecipients < Visma::Base
  self.table_name += 'MailRecipients'
  self.primary_key = 'Id'
  belongs_to :mail_archive, foreign_key: 'MailArchiveId'
  include Visma::Timestamp
  include Visma::ChangeBy
  include Visma::CreatedScopes
end
