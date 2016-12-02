# This table only have one row with the last numbers used in Visma Global
class Visma::LastNumbers < Visma::Base
  self.table_name += 'LastNumbers'
  self.primary_key = 'UniqueNo'

  class << self
    def LastCashInvoiceNo
      first.LastCashInvoiceNo
    end

    def LastCashNoteNo
      first.LastCashNoteNo
    end

    def LastConfirmationBatchNo
      first.LastConfirmationBatchNo
    end

    def LastCreditNoteNo
      first.LastCreditNoteNo
    end

    def LastInvoiceNo
      first.LastInvoiceNo
    end

    def LastPackListNo
      first.LastPackListNo
    end

    def LastPackingListBatchNo
      first.LastPackingListBatchNo
    end

    def LastPickingListBatchNo
      first.LastPickingListBatchNo
    end

    def LastPrintBatchNo
      first.LastPrintBatchNo
    end

    def LastUpdate
      first.LastUpdate
    end

    def LastUpdatedBy
      first.LastUpdatedBy
    end

    def LastVoucherNoProjectOrder
      first.LastVoucherNoProjectOrder
    end

    def LastVoucherNoPurchaseOrder
      first.LastVoucherNoPurchaseOrder
    end

    def LastVoucherNoUpdateStockValue
      first.LastVoucherNoUpdateStockValue
    end

    def UniqueNo
      first.UniqueNo
    end
  end
end
