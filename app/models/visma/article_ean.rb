class Visma::ArticleEan < Visma::Base
  self.table_name += 'ArticleEAN'
  self.primary_key = 'UnitTypeNo'

  include Visma::ArticleChange
  include Visma::SequenceNumber

  belongs_to :unit_type, foreign_key: :UnitTypeNo, primary_key: :UnitTypeNo
  belongs_to :article, primary_key: :ArticleNo, foreign_key: :ArticleNo

  validates :ArticleNo, :UnitTypeNo, :SeqNo, :EANNo, presence: true
  validates_with GtinValidator

  # Initialize with sequence number
  def initialize(*args)
    super
    set_sequence
    self.SmallestSalesUnitYesNo = 0
    self.EANGeneratedYesNo = 0
    self
  end

  # Find other ArticleEan on the same Article
  def siblings
    self.class.where(ArticleNo: self.ArticleNo)
  end

  # Return the GTIN number
  def gtin
    Rails.cache.fetch("visma_unit_#{self.UnitTypeNo}_gtin") do
      self.EANNo
    end
  end
end
