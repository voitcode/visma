module Visma
  # The email recipient
  class MailRecipient < Visma::Base
    self.table_name += 'MailRecipients'
    self.primary_key = 'Id'
    include Visma::Timestamp
    include Visma::ChangeBy
    include Visma::CreatedScopes

    belongs_to :mail_archive, foreign_key: 'MailArchiveId'
  end
end
