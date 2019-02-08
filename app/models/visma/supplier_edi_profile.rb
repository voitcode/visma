class Visma::SupplierEdiProfile < Visma::Base
  self.table_name += 'SupplierEdiProfile'
  self.primary_key = 'SupplierEdiProfileNo'

  belongs_to :edi_provider,
             primary_key: 'EDIProviderNo',
             foreign_key: 'EDIProviderNo',
             class_name: 'Visma::EdiProvider'
  has_many :edi_transactions,
           foreign_key: 'EDIProfileNo',
           class_name: 'Visma::EdiTransaction'
end
