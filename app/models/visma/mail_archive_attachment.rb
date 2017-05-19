module Visma
  # Attachments to emails sent by Visma
  class MailArchiveAttachment < Visma::Base
    self.table_name += 'MailArchiveAttachemts'
    self.primary_key = 'Id'
    include Visma::Timestamp
    include Visma::ChangeBy
    include Visma::CreatedScopes

    belongs_to :mail_archive, foreign_key: :MailArchieveId
  end
end
