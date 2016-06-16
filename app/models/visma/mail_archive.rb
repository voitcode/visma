class Visma::MailArchive < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "MailArchive"
  self.primary_key = "Id"
  include Visma::Timestamp
  include Visma::ChangeBy
  include Visma::CreatedScopes
end
