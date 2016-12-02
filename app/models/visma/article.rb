# This is the products table of Visma Global.
class Visma::Article < Visma::Base
  self.table_name += 'Article'
  self.primary_key = 'ArticleNo'
  include Visma::FullTimestamp

  # default scope with strange syntax to support joins
  default_scope { where('Article.ArticleNo NOT like(?)', '%+%') }

  # Enable active? and inactive? methods based on InActiveYesNo being 0 or 1
  enum InActiveYesNo: [:active, :inactive]

  has_many :unit_type, primary_key: :ArticleNo, foreign_key: :ArticleNo, inverse_of: :article
  alias_attribute :units, :unit_type

  has_many :article_ean, primary_key: :ArticleNo, foreign_key: :ArticleNo
  alias_attribute :gtins, :article_ean

  belongs_to :main_group, foreign_key: 'MainGroupNo', primary_key: 'MainGroupNo'
  belongs_to :intermediate_group, foreign_key: 'IntermediateGroupNo', primary_key: 'IntermediateGroupNo'
  belongs_to :sub_group, foreign_key: 'SubGroupNo', primary_key: 'SubGroupNo'

  belongs_to :posting_template_article, foreign_key: 'PostingTemplateNo', primary_key: 'PostingTemplateNo'

  belongs_to :price_markup_group, foreign_key: 'PriceMarkUpGroup'

  has_one :output_tax_class, through: :posting_template_article
  has_one :input_tax_class, through: :posting_template_article

  # Discount
  belongs_to :discount_group, foreign_key: 'DiscountGrpArtNo', class_name: DiscountGroupArticle
  has_many :discount_agreement_customer, foreign_key: 'ArticleNo'

  belongs_to :supplier, foreign_key: 'MainSupplierNo', primary_key: 'SupplierNo'

  # The Article is a variable weight product if the QuantityPerUnitTextSale is "KG"
  scope :variable_weight, -> { where("UPPER(QuantityPerUnitTextSale) = 'KG'") }
  scope :fixed_weight, -> { where("UPPER(QuantityPerUnitTextSale) != 'KG'") }

  has_many :customer_order_line_copies, foreign_key: 'ArticleNo'

  def price
    self.Price1
  end

  def agreed_price
    price
  end

  def discount
    0
  end

  def discount_factor
    0
  end

  def price_source
    'Artikkelpris'
  end

  def discount_source
    nil
  end

  # Price categorization
  def category
    self.class.to_s
  end

  # The Article is a variable weight product if the QuantityPerUnitTextSale is "KG"
  def variable_weight?
    self.QuantityPerUnitTextSale.to_s.casecmp('KG').zero?
  end

  # The Article is a fixed weight product is it isn't a variable weight one.
  def fixed_weight?
    !variable_weight?
  end

  # D-pak: http://www.stand.no/ordliste-2/?explanatory_dictionary_alphabet_letter=D
  def dpak
    unit_type.where("PackingType = 'D'").first
  end

  # F-pak: http://www.stand.no/ordliste-2/?explanatory_dictionary_alphabet_letter=F
  def fpak
    unit_type.where("PackingType = 'F'").first
  end

  # T-pak: A pallet, or transport unit
  def tpak
    unit_type.where("PackingType = 'T'").first
  end

  def fpak_ean
    article_ean.joins(:unit_type).where("PackingType = 'F'").first
  end

  def fpak_gtin
    Rails.cache.fetch("#{cache_key}/fpak-gtin") do
      fpak_ean.try(:EANNo)
    end
  end

  # Set GTIN on FPAK
  def fpak_gtin=(value)
    return nil if fpak.nil?

    if fpak_ean.nil?
      ean = article_ean.create(UnitTypeNo: fpak.UnitTypeNo, EANNo: value)
    else
      ean = fpak_ean
      ean.update_attribute(:EANNo, value)
    end

    reload

    errors[:article_ean] = ean.errors unless ean.errors.blank?
    ean.try(:EANNo)
  end

  def dpak_ean
    article_ean.joins(:unit_type).where("PackingType = 'D'").first
  end

  def dpak_gtin
    Rails.cache.fetch("#{cache_key}/dpak-gtin") do
      dpak_ean.try(:EANNo)
    end
  end

  # Set GTIN on DPAK
  def dpak_gtin=(value)
    return nil if dpak.nil?

    if dpak_ean.nil?
      ean = article_ean.create(UnitTypeNo: dpak.UnitTypeNo, EANNo: value)
    else
      ean = dpak_ean
      ean.update_attribute(:EANNo, value)
    end

    reload
    errors[:article_ean] = ean.errors unless ean.errors.blank?
    ean.try(:EANNo)
  end

  def tpak_ean
    article_ean.joins(:unit_type).where("PackingType = 'T'").first
  end

  def tpak_gtin
    Rails.cache.fetch("#{cache_key}/tpak-gtin") do
      tpak_ean.try(:EANNo)
    end
  end

  # Set GTIN on TPAK
  def tpak_gtin=(value)
    return nil if tpak.nil?

    if tpak_ean.nil?
      ean = article_ean.create(UnitTypeNo: tpak.UnitTypeNo, EANNo: value)
    else
      ean = tpak_ean
      ean.update_attribute(:EANNo, value)
    end

    reload
    errors[:article_ean] = ean.errors unless ean.errors.blank?
    ean.try(:EANNo)
  end

  def storage_type
    return 'Kjøl' if self.StorageTypeNo == 1

    return 'Frys' if self.StorageTypeNo == 2

    return 'Tørrvare' if self.StorageTypeNo == 3
  end

  def sort_me
    self.ArticleNo
  end

  def to_s
    "#{id} #{self.Name}"
  end
end
