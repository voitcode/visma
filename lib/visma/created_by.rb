module Visma
  # Return Visma::Logonuser for change fields
  module CreatedBy
    extend ActiveSupport::Concern

    included do
      belongs_to :created_by, foreign_key: 'CreatedBy', class_name: :LogonUser
    end

    def updated_by
      created_by
    end
  end
end
