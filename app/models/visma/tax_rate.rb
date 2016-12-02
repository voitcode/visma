class Visma::TaxRate < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "TaxRate"

  default_scope { order(ComeIntoForce: :asc) }

  belongs_to :tax_class, foreign_key: "TaxClassNo"
end
