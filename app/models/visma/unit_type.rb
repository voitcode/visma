class Visma::UnitType < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "UnitType"
  self.primary_key = "UnitTypeNo"

  self.use_activerecord_cache = true
  include Visma::Timestamp

  # Don't query UnitTypes where the sales unit is inactive
  default_scope { where("UnitInSales != 1") }

  belongs_to :article, primary_key: :ArticleNo, foreign_key: :ArticleNo, inverse_of: :unit_type

  has_one :article_ean, primary_key: :UnitTypeNo, foreign_key: :UnitTypeNo

  # Disable unit
  def disable!
    self.UnitInSales = 1
    self.save
  end

  # Return GTIN number
  def gtin
    Rails.cache.fetch("visma_unit_#{self.UnitTypeNo}_gtin") do
      article_ean.try(:EANNo)
    end
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

  # Calculation method
  def calc
    self.FactorCalcMethod == 0 ? "*" : "/"
  end

  # This Unit can be used in order, for sale
  def for_sale?
    self.UnitInSales != 1
  end

  # Timestamp
  def updated_at
    self.LastUpdate
  end
end
