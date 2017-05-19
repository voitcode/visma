module Visma
  # Emails sent by Visma
  class MailArchive < Visma::Base
    self.table_name += 'MailArchive'
    self.primary_key = 'Id'
    include Visma::Timestamp
    include Visma::ChangeBy
    include Visma::CreatedScopes

    has_many :attachments,
             foreign_key: :MailArchieveId,
             class_name: Visma::MailArchiveAttachment
    has_many :recipients,
             foreign_key: :MailArchiveId,
             class_name: Visma::MailRecipient

    belongs_to :customer_order_copy,
               primary_key: :InvoiceNo,
               foreign_key: :MessageReference
  end
end
