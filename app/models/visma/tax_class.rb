class Visma::TaxClass < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "TaxClass"
  self.primary_key = "TaxClassNo"

  has_many :tax_rate, foreign_key: "TaxClassNo"
end
