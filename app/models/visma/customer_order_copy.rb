class Visma::CustomerOrderCopy < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerOrderCopy"
  self.primary_key = "OrderCopyNo"

  has_many :customer_order_line_copy, foreign_key: :OrderCopyNo, primary_key: :OrderCopyNo

  has_many :invoice_no_lines, foreign_key: :InvoiceNo, primary_key: :InvoiceNo, class_name: "CustomerOrderLineCopy"
  has_many :common_invoice_id_lines, foreign_key: :InvoiceNo, primary_key: :InvoiceNo, class_name: "CustomerOrderLineCopy"

  belongs_to :customer, foreign_key: :CustomerNo, primary_key: :CustomerNo

  alias :order_line :customer_order_line_copy

  def OrderNo
    self.OrderCopyNo
  end

  # Find the Huldt & Lillevik employee
  def employee
    Hlonn::Personer.find_by_name(self.SortName) or Hlonn::Personer.new
  end

  # Select all employee orders
  def self.all_employee_orders
    where(ChainNo: 49999).where(TypeOfChain: 1).
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
