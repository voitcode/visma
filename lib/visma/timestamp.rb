module Visma
  module Timestamp
    extend ActiveSupport::Concern

    included do
      before_save :set_timestamp
    end

    alias_attribute :updated_at, :LastUpdate

    # Set timestamp
    def set_timestamp
      self.LastUpdate = Time.zone.now
      self.LastUpdatedBy = 1
    end

    # Timestamp
    def max_updated_column_timestamp
      self.LastUpdate
    end
  end
end
