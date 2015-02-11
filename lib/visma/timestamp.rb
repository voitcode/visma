module Visma
  module Timestamp
    extend ActiveSupport::Concern

    included do
      before_save :set_timestamp
    end

    alias_attribute :updated_at, :LastUpdate

    # Set timestamp
    def set_timestamp
      offset = Time.zone_offset(VISMA_CONFIG["time_zone"])
      raise VismaError, "You MUST configure a valid time_zone in config/visma.yml" if offset.nil?

      self.LastUpdate = Time.zone.now + offset
      self.LastUpdatedBy = 1
    end

    # Timestamp
    def max_updated_column_timestamp
      self.LastUpdate
    end
  end
end
