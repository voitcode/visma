class Visma::TaxClass < Visma::Base
  self.table_name += 'TaxClass'
  self.primary_key = 'TaxClassNo'

  has_many :tax_rate, foreign_key: 'TaxClassNo'
end
