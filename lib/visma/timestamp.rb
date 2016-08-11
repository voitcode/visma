module Visma
  # Update Visma-compatbile timestamp
  module Timestamp
    extend ActiveSupport::Concern

    included do
      before_save :set_blame

      # Scope queries in time ranges
      scope :updated_between, ->(range) {
        first = range.first.strftime("%Y-%m-%d %H:%M:%S")
        last  =  range.last.strftime("%Y-%m-%d %H:%M:%S")
        where("LastUpdate BETWEEN ? AND ?", first, last)
      }
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

    def timestamp_attributes_for_update
      [:LastUpdate]
    end
    alias_attribute :updated_at, :LastUpdate

    def timestamp_attributes_for_create
      [:Created]
    end
    alias_attribute :created_at, :Created

    # Set who to blame for the latest change when saving
    def set_blame
      self.CreatedBy = 1 if new_record?
      self.LastUpdatedBy = 1 if changed?
    end

  end
end
