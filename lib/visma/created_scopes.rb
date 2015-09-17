module Visma

  # Scoped queries in time ranges for created
  module Created
    included do
      scope :created_today,           -> { where(Created: Time.now.beginning_of_day..Time.now) }
      scope :created_this_week,       -> { where(Created: Time.now.beginning_of_week..Time.now) }
      scope :created_previous_week,   -> { where(Created: 1.week.ago.beginning_of_week..1.week.ago.end_of_week) }
      scope :created_last_week,       -> { where(Created: 1.week.ago..Time.now) }
      scope :created_this_month,      -> { where(Created: Time.now.beginning_of_month..Time.now) }
      scope :created_previous_month,  -> { where(Created: 1.month.ago.beginning_of_month..1.month.ago.end_of_month) }
      scope :created_last_month,      -> { where(Created: 1.month.ago..Time.now) }
      scope :created_this_year,       -> { where(Created: Time.now.beginning_of_year..Time.now) }
      scope :created_previous_year,   -> { where(Created: 1.year.ago.beginning_of_year..1.year.ago.end_of_year) }
      scope :created_last_year,       -> { where(Created: 1.year.ago..Time.now) }
    end
  end
end
