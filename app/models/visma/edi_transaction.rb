module Visma
  # EDI message logs
  class EDITransaction < Visma::Base
    self.table_name += 'EDITransaction'
    self.primary_key = 'UniqueNo'

    include Visma::Timestamp
    include Visma::ChangeBy
    include Visma::CreatedScopes
    include Visma::CreatedBy

    belongs_to :edi_provider,
               foreign_key: 'EDIProviderNo',
               class_name: Visma::EDIProvider
    belongs_to :edi_profile,
               foreign_key: 'EDIProfileNo',
               class_name: Visma::CustomerEdiProfile
    belongs_to :customer,
               foreign_key: 'PartyID',
               class_name: Visma::Customer
    belongs_to :customer_order_copy,
               foreign_key: 'DocNo',
               primary_key: 'InvoiceNo'
    alias invoice customer_order_copy

    enum Status: { rejected: 3, sent: 5 }

    # Was this transaction rejected due to order sums?
    def order_summary_failed?
      return false unless rejected?
      return true if self.EventLog =~ /Validering av summer feilet/
      false
    end

    # Fetch the invoice's deviating rounding amount from the event log
    def deviating_rounding_amount
      self.EventLog.lines.last[/avvik: \d\.\d\d/][/\d.\d\d/].to_f
    rescue
      0
    end

    # Correct the invoice's rounding amount according to event log error
    def fix_invoice_rounding_amount
      invoice.RoundingAmount -= deviating_rounding_amount
      invoice
    end
  end
end
