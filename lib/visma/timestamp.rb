module Visma
  # Update Visma-compatbile timestamp
  module Timestamp
    extend ActiveSupport::Concern

    included do
      before_save :set_timestamp
    end

    alias_attribute :updated_at, :LastUpdate

    def set_timestamp
      offset = TZInfo::Timezone.get(VISMA_CONFIG["time_zone"]).current_period.utc_offset
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
