module Visma
  # Update Visma-compatbile timestamp
  module Timestamp
    extend ActiveSupport::Concern

    included do
      before_save :set_timestamp

      # Scope queries in time ranges
      scope :updated_today,           -> { where(LastUpdate: Time.now.beginning_of_day..Time.now) }
      scope :updated_this_week,       -> { where(LastUpdate: Time.now.beginning_of_week..Time.now) }
      scope :updated_previous_week,   -> { where(LastUpdate: 1.week.ago.beginning_of_week..1.week.ago.end_of_week) }
      scope :updated_last_week,       -> { where(LastUpdate: 1.week.ago..Time.now) }
      scope :updated_this_month,      -> { where(LastUpdate: Time.now.beginning_of_month..Time.now) }
      scope :updated_previous_month,  -> { where(LastUpdate: 1.month.ago.beginning_of_month..1.month.ago.end_of_month) }
      scope :updated_last_month,      -> { where(LastUpdate: 1.month.ago..Time.now) }
      scope :updated_this_year,       -> { where(LastUpdate: Time.now.beginning_of_year..Time.now) }
      scope :updated_previous_year,   -> { where(LastUpdate: 1.year.ago.beginning_of_year..1.year.ago.end_of_year) }
      scope :updated_last_year,       -> { where(LastUpdate: 1.year.ago..Time.now) }
    end

    alias_attribute :updated_at, :LastUpdate

    # Fetch the newest LastUpdate timestamp
    def self.latest_update
      order(LastUpdate: :desc).first.LastUpdate
    end

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
