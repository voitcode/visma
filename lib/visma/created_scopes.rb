module Visma
  # Scoped queries in time ranges for created
  module CreatedScopes
    extend ActiveSupport::Concern

    included do
      scope :created_between, lambda { |range|
        first = range.first.strftime('%Y-%m-%d %H:%M:%S')
        last = range.last.strftime('%Y-%m-%d %H:%M:%S')
        where('Created BETWEEN ? AND ?', first, last)
      }
      scope :created_today,           -> { created_between(Time.now.beginning_of_day..Time.now) }
      scope :created_yesterday,       -> { created_between(1.day.ago.beginning_of_day..1.day.ago.end_of_day) }
      scope :created_this_week,       -> { created_between(Time.now.beginning_of_week..Time.now) }
      scope :created_previous_week,   -> { created_between(1.week.ago.beginning_of_week..1.week.ago.end_of_week) }
      scope :created_last_week,       -> { created_between(1.week.ago..Time.now) }
      scope :created_this_month,      -> { created_between(Time.now.beginning_of_month..Time.now) }
      scope :created_previous_month,  -> { created_between(1.month.ago.beginning_of_month..1.month.ago.end_of_month) }
      scope :created_last_month,      -> { created_between(1.month.ago..Time.now) }
      scope :created_this_year,       -> { created_between(Time.now.beginning_of_year..Time.now) }
      scope :created_previous_year,   -> { created_between(1.year.ago.beginning_of_year..1.year.ago.end_of_year) }
      scope :created_last_year,       -> { created_between(1.year.ago..Time.now) }
    end
  end
end
