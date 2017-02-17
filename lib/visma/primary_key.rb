module Visma
  # Set and validate the primary key before saving a record
  module PrimaryKey
    included do
      validates primary_key, presence: true
    end
  end
end
