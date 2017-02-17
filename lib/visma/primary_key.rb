module Visma
  # Set and validate the primary key before saving a record
  module PrimaryKey
    included do
      validates primary_key, presence: true

      before_create :generate_primary_key
    end
  end
end
