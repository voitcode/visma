module Visma
  # Set and validate the primary key before saving a record
  module PrimaryKey
    extend ActiveSupport::Concern
    included do
      validates primary_key, presence: true
      before_create :generate_primary_key
    end
  end
end
