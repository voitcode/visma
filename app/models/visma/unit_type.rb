class Visma::UnitType < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "UnitType"
  self.primary_key = "UnitTypeNo"

  self.use_activerecord_cache = true

  # Don't query UnitTypes where the sales unit is inactive
  default_scope { where("CAST(UnitInSales AS integer) != 1") }

  belongs_to :article, primary_key: :ArticleNo, foreign_key: :ArticleNo

  has_one :article_ean, primary_key: :UnitTypeNo, foreign_key: :UnitTypeNo

  # Disable unit
  def disable!
    self.UnitInSales = 1
    self.save
  end

  # Return GTIN number
  def gtin
    article_ean.try(:EANNo)
  end

  # Return Unit Status
  def status
    {
      0 => "Kan brukes",
      1 => "Ikke i bruk",
      2 => "Grunnenhet",
      9 => "Standard"
    }[self.UnitInSales]
  end
end
