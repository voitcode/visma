class Visma::CustomerOrderCopy < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerOrderCopy"
  self.primary_key = "OrderCopyNo"
  self.use_activerecord_cache = true

  include Visma::StaticTimestamp
  include Visma::CreatedBy

  include Visma::CreatedScopes
  belongs_to :customer, foreign_key: :CustomerNo
  belongs_to :chain, foreign_key: :ChainNo, primary_key: :CustomerNo, class_name: Visma::Customer

  has_many :customer_order_line_copies, foreign_key: :OrderCopyNo
  alias :order_lines :customer_order_line_copies

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
