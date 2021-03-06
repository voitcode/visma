module Visma
  # Also called Invoice
  class CustomerOrderCopy < Visma::Base
    self.table_name += 'CustomerOrderCopy'
    self.primary_key = 'OrderCopyNo'

    include Visma::StaticTimestamp
    include Visma::CreatedBy
    include Visma::CreatedScopes

    belongs_to :customer, foreign_key: :CustomerNo
    belongs_to :chain,
               foreign_key: :ChainNo,
               primary_key: :CustomerNo,
               class_name: 'Visma::Customer'

    belongs_to :employee, foreign_key: :EmployeeNo
    belongs_to :our_reference,
               foreign_key: :OurRef,
               primary_key: :Name,
               class_name: 'Visma::Employee'

    # Form profile: Which papers to use
    belongs_to :form_profile_customer, foreign_key: :FormProfileCustNo
    # Print profile: How to send papers
    belongs_to :print_profile, foreign_key: :PrintProfileNo
    # EDI profile: How to electronically send order data
    belongs_to :customer_edi_profile, foreign_key: :EdiProfileNo
    # Customer profile: How to handle the customer financially
    belongs_to :customer_profile, foreign_key: :CustomerProfileNo

    has_many :customer_order_line_copies, foreign_key: :OrderCopyNo
    alias order_lines customer_order_line_copies

    has_many :edi_transactions, primary_key: :InvoiceNo, foreign_key: :DocNo

    enum OrderStatus: {
      system_invoiced: 1030,
      user_invoiced: 1000,
      nullified: -1,
      for_picking: 1015
    }

    scope :invoiced, -> { where(OrderStatus: [1030, 1000]) }

    scope :factoring, lambda {
      where(CustomerProfileNo: VISMA_CONFIG['factoring_customer_profile_number'])
        .where(FormProfileCustNo: VISMA_CONFIG['factoring_form_profile_number'])
        .where('FactCustomerNo = CustomerNo')
    }

    # The email sent by Global if this order was billed by the system
    def system_generated_invoice_email
      Visma::MailArchive.where("Subject LIKE '%?%'", self.InvoiceNo)
    end

    # is this a batch invoice?
    def a_batch_invoice?
      invoice_batch.count != 1
    end
    alias is_a_batch_invoice? a_batch_invoice?

    # return batch invoice order lines
    def invoice_lines
      Visma::CustomerOrderLineCopy.where(InvoiceNo: self.InvoiceNo)
    end

    # return invoice batch orders
    def invoice_batch
      self.class.where(InvoiceNo: self.InvoiceNo)
    end

    # return sum of TotalAmount
    def invoice_total
      invoice_batch.map(&:TotalAmount).sum
    end

    # return sum of TotalGross
    def invoice_gross
      invoice_batch.map(&:TotalGross).sum
    end

    # compatibilty method
    def OrderNo
      self.OrderCopyNo
    end

    # Recalculate TotalAmount
    def calculate_rounding_amount
      tot = self.TotalGross
      amt = (self.TotalAmount + self.TotalVAT)
      sum = (amt * 100).ceil / 100.0
      self.RoundingAmount = (tot - sum).round(2)
    end

    # Select all employee orders
    def self.all_employee_orders
      where(ChainNo: VISMA_CONFIG['employee_chain_number'])
        .where(TypeOfChain: 1)
        .where(InvoiceDate: DateTime.new(2014)..DateTime.now)
        .where('TotalGross != 0')
    end

    # All employee orders, since PrintBatchNo
    def self.all_employee_orders_after(no)
      all_employee_orders
        .where(['PrintBatchNo > ?', no])
    end

    # A given employee's orders after PrintBatchNo
    def self.employee_orders_after(emp, no)
      all_employee_orders_after(no)
        .where(CustomerNo: emp)
    end

    # Last print batch
    def self.last_print_batch
      order(:PrintBatchNo).last.PrintBatchNo
    end

    # All employee orders, between PrintBatchNo
    def self.all_employee_orders_between(f, t)
      all_employee_orders
        .where(['PrintBatchNo >= ?', f])
        .where(['PrintBatchNo <= ?', t])
    end

    # A given employee's orders between PrintBatchNo
    def employee_orders_between(emp, f, t)
      all_employee_orders_between(f, t)
        .where(CustomerNo: emp)
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
      %w(InvoiceNo InvoiceDate TotalGross CustomerNo SortName PrintBatchNo)
    end

    # Visma::MailArchive message reference for this invoice
    def mail_archive_reference
      "#{self.InvoiceNo}, Print #{self.PrintBatchNo}"
    end

    # Emails that belongs to this invoice
    def emails
      MailArchive.where(MessageReference: mail_archive_reference)
    end

    # Fetch the email attached PDF invoice
    def to_pdf
      return nil unless File.directory?(Rails.root.join('tmp'))
      return nil if emails.blank?
      file = "tmp/#{self.InvoiceNo}.pdf"
      File.open(Rails.root.join(*file), 'w:ASCII-8BIT') do |pdf|
        pdf.write emails.first.attachment.Data
      end
      self.InvoiceNo
    end
  end
end
