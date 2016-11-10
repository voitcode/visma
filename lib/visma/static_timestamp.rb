module Visma
  # Visma-compatbile timestamp for final records
  module StaticTimestamp
    extend ActiveSupport::Concern

    included do
      # Fetch the newest LastUpdate timestamp
      def self.latest_update
        order(Created: :desc).first.Created
      end
    end

    alias_attribute :updated_at, :Created

    # Timestamp
    def max_updated_column_timestamp
      self.Created
    end
  end
end
