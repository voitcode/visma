class Visma::CustomerOrderCopy < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerOrderCopy"
  self.primary_key = "OrderCopyNo"

  has_many :customer_order_line_copy, foreign_key: :OrderCopyNo, primary_key: :OrderCopyNo
  alias :order_lines :customer_order_line_copy

  has_many :invoice_no_lines, foreign_key: :InvoiceNo, primary_key: :InvoiceNo, class_name: Visma::CustomerOrderLineCopy
  has_many :common_invoice_id_lines, foreign_key: :InvoiceNo, primary_key: :InvoiceNo, class_name: Visma::CustomerOrderLineCopy

  belongs_to :customer, foreign_key: :CustomerNo, primary_key: :CustomerNo
  belongs_to :chain, foreign_key: :ChainNo, primary_key: :CustomerNo, class_name: Visma::Customer

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

  def OrderNo
    self.OrderCopyNo
  end

  # Find the Huldt & Lillevik employee
  def employee
    Hlonn::Personer.find_by_name(self.SortName) or Hlonn::Personer.new
  end

  # Select all employee orders
  def self.all_employee_orders
    where(ChainNo: VISMA_CONFIG["employee_chain_number"]).where(TypeOfChain: 1).
      where(InvoiceDate: DateTime.new(2014)..DateTime.now).
      where("TotalGross > 0")
  end

  # All employee orders, since PrintBatchNo
  def self.all_employee_orders_after(no)
    all_employee_orders.
      where(["PrintBatchNo > ?", no])
  end

  # A given employee's orders after PrintBatchNo
  def self.employee_orders_after(emp, no)
    all_employee_orders_after(no).
      where(CustomerNo: emp)
  end

  # Last print batch
  def self.last_print_batch
    order(:PrintBatchNo).last.PrintBatchNo
  end

  # All employee orders, between PrintBatchNo
  def self.all_employee_orders_between(f, t)
    all_employee_orders.
      where(["PrintBatchNo >= ?", f]).
      where(["PrintBatchNo <= ?", t])
  end

  # A given employee's orders between PrintBatchNo
  def employee_orders_between(emp, f, t)
    all_employee_orders_between(f,t).
      where(CustomerNo: emp)
  end

  # Generate given orders to CSV using selected columns
  def self.to_csv(orders)
    CSV.generate do |csv|
      csv << csv_columns
      orders.each do |order|
        csv << order.attributes.values_at(*csv_columns)
      end
    end
  end

  # Selected columns for CSV and employee_orders
  def self.csv_columns
    ["InvoiceNo","InvoiceDate","TotalGross","CustomerNo","SortName","PrintBatchNo"]
  end
end
