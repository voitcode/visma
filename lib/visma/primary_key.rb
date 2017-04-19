module Visma
  # Set and validate the primary key before saving a record
  module PrimaryKey
    extend ActiveSupport::Concern
    included do
      validates primary_key, presence: true
      before_validation :generate_primary_key
    end

    def generate_primary_key
      self[self.class.primary_key] ||= self.class.new_primary_key
    end

    # Methods included at the class level
    module ClassMethods
      # Retrieve a new primary key
      def new_primary_key(minimum = 1)
        existing = unscoped.pluck(primary_key).sort
        numbers = minimum..existing.last
        new_number = numbers.detect { |n| !existing.include?(n) }
        new_number || existing.last + 1
      end
    end
  end
end
