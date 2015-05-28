class Visma::CustomerOrderLineCopy < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerOrderLineCopy"
  self.primary_key = "OrderCopyNo"

  # Scope orders in time ranges
  scope :today,  -> { where("Created <= ? AND Created >= ?", Date.today.at_end_of_day, Date.today) }
  scope :this_week,  -> { where("Created <= ? AND Created >= ?", Date.today, Date.today.beginning_of_week) }
  scope :previous_week,  -> { where("Created <= ? AND Created >= ?", 1.week.ago.end_of_week, 1.week.ago.beginning_of_week) }
  scope :last_week,  -> { where("Created <= ? AND Created >= ?", Date.today, 1.week.ago) }
  scope :this_month, -> { where("Created <= ? AND Created >= ?", Date.today, Date.today.beginning_of_month) }
  scope :previous_month, -> { where("Created <= ? AND Created >= ?", 1.month.ago.end_of_month, 1.month.ago.beginning_of_month) }
  scope :last_month, -> { where("Created <= ? AND Created >= ?", Date.today, 1.month.ago) }
  scope :this_year,  -> { where("Created <= ? AND Created >= ?", Date.today, Date.today.beginning_of_year) }
  scope :previous_year, -> { where("Created <= ? AND Created >= ?", 1.year.ago.end_of_year, 1.year.ago.beginning_of_year) }
  scope :last_year,  -> { where("Created <= ? AND Created >= ?", Date.today, 1.year.ago) }
end
