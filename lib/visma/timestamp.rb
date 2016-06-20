module Visma
  # Update Visma-compatbile timestamp
  module Timestamp
    extend ActiveSupport::Concern

    included do
      before_save :set_timestamp

      # Scope queries in time ranges
      scope :updated_between, ->(range) { where(LastUpdate: range) }
      scope :updated_today,           -> { updated_between(Time.now.beginning_of_day..Time.now) }
      scope :updated_yesterday,       -> { updated_between(1.day.ago.beginning_of_day..1.day.ago.end_of_day) }
      scope :updated_this_week,       -> { updated_between(Time.now.beginning_of_week..Time.now) }
      scope :updated_previous_week,   -> { updated_between(1.week.ago.beginning_of_week..1.week.ago.end_of_week) }
      scope :updated_last_week,       -> { updated_between(1.week.ago..Time.now) }
      scope :updated_this_month,      -> { updated_between(Time.now.beginning_of_month..Time.now) }
      scope :updated_previous_month,  -> { updated_between(1.month.ago.beginning_of_month..1.month.ago.end_of_month) }
      scope :updated_last_month,      -> { updated_between(1.month.ago..Time.now) }
      scope :updated_this_year,       -> { updated_between(Time.now.beginning_of_year..Time.now) }
      scope :updated_previous_year,   -> { updated_between(1.year.ago.beginning_of_year..1.year.ago.end_of_year) }
      scope :updated_last_year,       -> { updated_between(1.year.ago..Time.now) }

      # Fetch the newest LastUpdate timestamp
      def self.latest_update
        order(LastUpdate: :desc).first.LastUpdate
      end
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
