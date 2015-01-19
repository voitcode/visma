class Visma::UnitType < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "UnitType"
  self.primary_key = "UnitTypeNo"

  self.use_activerecord_cache = true
  include Visma::Timestamp
  include Visma::ArticleChange

  # Don't query UnitTypes where the sales unit is inactive
  default_scope { where("UnitInSales != 1") }

  belongs_to :article, primary_key: :ArticleNo, foreign_key: :ArticleNo, inverse_of: :unit_type
  belongs_to :unit, primary_key: :UnitNo, foreign_key: :UnitNo
  has_one :article_ean, primary_key: :UnitTypeNo, foreign_key: :UnitTypeNo

  validates :UnitTypeNo, uniqueness: true, presence: true

  # Initialize with UnitTypeNo
  def initialize(*args)
    super
    self.UnitTypeNo = Visma::UnitType.unscoped.order(:UnitTypeNo).last.UnitTypeNo + 1
    self.WareHouseNo = 0
    self.Factor = 1
    self.UtilityBits = "\x00\x00\x00\x00\x00\x00"
    self.LastUpdate = Time.zone.now
    self.LastUpdatedBy = 11
    self.Created = Time.zone.now
    self.CreatedBy = 1
    self.PreviousUnit = 0
    self.Height = 0.0
    self.VariableQtyYesNo = 1
    self.Width = 0.0
    self.Length = 0.0
    self.Volume = 0.0
    self.Rounding = 0
    self.PriceListNo = 0
    self.UnitInPurchase = 0
    self.SplitPurchaseYesNo = 0
    self.UnitInSales = 0
    self.SplitSalesYesNo = 0
    self.FactorCalcMethod = 0
    self.Weight = 0.0
    self.ComparableUnitYesNo = 0
    self.Location = ""
    self.Name = Visma::Unit.find(self.UnitNo).UnitName
    self.UnitNamePurchase = self.Name
    return self
  end

  # Disable unit
  def disable!
    self.UnitInSales = 1
    self.save
  end

  # Return GTIN number
  def gtin
    article_ean.try(:EANNo)
  end

  # Return the unit text
  def text
    Visma::Unit.all.to_a[self.UnitNo - 1].UnitName
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
end
