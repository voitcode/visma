class Visma::EdiProvider < Visma::Base
  self.table_name += 'EDIProvider'
  self.primary_key = 'EDIProviderNo'

  has_many :supplier_edi_profiles, foreign_key: 'SupplierEdiProfileNo'
  has_many :edi_transactions,
           foreign_key: 'EDIProviderNo',
           class_name: 'Visma::EdiTransaction'
end
