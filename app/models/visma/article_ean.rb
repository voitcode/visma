class Visma::ArticleEan < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "ArticleEAN"
  self.primary_key = "UnitTypeNo"

  belongs_to :unit_type, foreign_key: :UnitTypeNo, primary_key: :UnitTypeNo
  belongs_to :article, primary_key: :ArticleNo, foreign_key: :ArticleNo

  validates :ArticleNo, :UnitTypeNo, :SeqNo, presence: true

  # Initialize with sequence number
  def initialize(*args)
    super
    set_sequence
    self.SmallestSalesUnitYesNo = 0
    self.EANGeneratedYesNo = 0
    return self
  end

  def siblings
    self.class.where(ArticleNo: self.ArticleNo)
  end

  def sequence
    siblings.map(&:SeqNo).collect {|n| n.to_s.sub(/0+$/,'').to_i }.sort
  end

  def set_sequence
    seq = ( sequence.last rescue 1000 ) + 1
    self.SeqNo = ("%08d" % seq.to_s.reverse).reverse.to_i
  end
end
