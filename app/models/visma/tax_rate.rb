class Visma::TaxRate < Visma::Base
  self.table_name += 'TaxRate'

  default_scope { order(ComeIntoForce: :asc) }

  belongs_to :tax_class, foreign_key: 'TaxClassNo'
end
