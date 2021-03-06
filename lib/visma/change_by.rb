module Visma
  # Return Visma::Logonuser for change fields
  module ChangeBy
    extend ActiveSupport::Concern

    included do
      belongs_to :last_updated_by, foreign_key: 'LastUpdatedBy', class_name: 'LogonUser'
      belongs_to :created_by, foreign_key: 'CreatedBy', class_name: 'LogonUser'
    end

    def updated_by
      last_updated_by || created_by
    end
  end
end
