#
# = Article
#
# This is the products table of Visma Global. Look here to find every product defined.
#
class Visma::Article < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "Article"
  self.primary_key = "ArticleNo"
  #include ::Sorting

  self.use_activerecord_cache = true
  include Visma::Timestamp

  default_scope { where("ArticleNo NOT like(?)", "%+%") }

  # Enable active? and inactive? methods based on InActiveYesNo being 0 or 1
  enum :InActiveYesNo => [ :active, :inactive ]

  has_many :unit_type, primary_key: :ArticleNo, foreign_key: :ArticleNo, inverse_of: :article
  alias_attribute :units, :unit_type

  has_many :article_ean, primary_key: :ArticleNo, foreign_key: :ArticleNo
  alias_attribute :gtins, :article_ean

  belongs_to :main_group, foreign_key: "MainGroupNo", primary_key: "MainGroupNo"
  belongs_to :intermediate_group, foreign_key: "IntermediateGroupNo", primary_key: "IntermediateGroupNo"
  belongs_to :sub_group, foreign_key: "SubGroupNo", primary_key: "SubGroupNo"

  belongs_to :posting_template_article, foreign_key: "PostingTemplateNo", primary_key: "PostingTemplateNo"

  belongs_to :price_markup_group, foreign_key: "PriceMarkUpGroup"

  has_one :output_tax_class, through: :posting_template_article
  has_one :input_tax_class, through: :posting_template_article

  # Discount
  belongs_to :discount_group, foreign_key: "DiscountGrpArtNo", class_name: DiscountGroupArticle
  has_many :discount_agreement_customer, foreign_key: "ArticleNo"

  belongs_to :supplier, foreign_key: "MainSupplierNo", primary_key: "SupplierNo"

  scope :variable_weight, where("UPPER(QuantityPerUnitTextSale) = 'KG'")
  scope :fixed_weight, where("UPPER(QuantityPerUnitTextSale) != 'KG'")

  # The Article is a variable weight product if the QuantityPerUnitTextSale is "KG"
  def variable_weight?
    self.QuantityPerUnitTextSale.to_s.upcase == "KG"
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
    fpak_ean.try(:EANNo)
  end

  # Set GTIN on FPAK
  def fpak_gtin=(value)
    return nil if fpak.nil?

    if fpak_ean.nil?
      article_ean.create(UnitTypeNo: fpak.UnitTypeNo, EANNo: value)
    else
      fpak_ean.update_attribute(:EANNo, value)
    end

    self.reload
    return fpak_ean.EANNo
  end

  def dpak_ean
    article_ean.joins(:unit_type).where("PackingType = 'D'").first
  end

  def dpak_gtin
    dpak_ean.try(:EANNo)
  end

  # Set GTIN on DPAK
  def dpak_gtin=(value)
    return nil if dpak.nil?

    if dpak_ean.nil?
      article_ean.create(UnitTypeNo: dpak.UnitTypeNo, EANNo: value)
    else
      dpak_ean.update_attribute(:EANNo, value)
    end

    self.reload
    return dpak_ean.EANNo
  end

  def tpak_ean
    article_ean.joins(:unit_type).where("PackingType = 'T'").first
  end

  def tpak_gtin
    tpak_ean.try(:EANNo)
  end

  # Set GTIN on TPAK
  def tpak_gtin=(value)
    return nil if tpak.nil?

    if tpak_ean.nil?
      article_ean.create(UnitTypeNo: tpak.UnitTypeNo, EANNo: value)
    else
      tpak_ean.update_attribute(:EANNo, value)
    end

    self.reload
    return tpak_ean.EANNo
  end

  def storage_type
    if self.StorageTypeNo == 1
      return "Kjøl"
    end

    if self.StorageTypeNo == 2
      return "Frys"
    end

    if self.StorageTypeNo == 3
      return "Tørrvare"
    end
  end

  def sort_me
    self.ArticleNo
  end

  # Find matching Prosim Kalkfv
  def prosim_kalkfv
    Prosim::Kalkfv.find(self.ArticleNo) rescue nil
  end

  # How different is the Prosim name
  def namediff
    100.0 - self.Name.similar(self.prosim_kalkfv.FVNAVN) rescue 100.0
  end

  # update PurchasePrice from Prosim "Sum dir.kost."
  # Return true if new price is found, otherwise false
  def fetch_prosim_price
    fv = self.prosim_kalkfv
    return false if fv.nil?

    price = fv.sum_dir_kost.round(2)
    return false if self.PurchasePrice == price

    self.PurchasePrice = price
    return true
  end

  # All articles missing in Prosim
  def self.missing_in_prosim
    change = File.mtime("db/Pro_d.mdb")
    Rails.cache.fetch("prosim_missing_#{change}") do
      list = list2 = list3 = []
      list = Visma::Article.active.pluck(:ArticleNo).map {|a| a.to_i } - [0]
      list2 = Prosim::Kalkfv.pluck(:FVNR)

      list.sort!
      until list.empty?
        n = list.pop
        unless n < 100 or list2.include?(n)
          list3 << Visma::Article.where(ArticleNo: n.to_s).first
        end
      end
      list3.compact!
    end
  end

  # All articles present and with all values in Prosim
  def self.complete_in_prosim
    nr = Prosim::Kalkfv.pluck(:FVNR)
    p = []
    until nr.empty?
      n = nr.pop(15)
      p << where(ArticleNo: n.map(&:to_s)).to_a
    end
    p = p.flatten.compact - Prosim::Kalkfv.missing_values(true)
    return p.sort_by {|a| a.ArticleNo.to_i }
  end

  # All product with new Prosim price
  def self.prosim_price_diff
    change = File.mtime("db/Pro_d.mdb")
    Rails.cache.fetch("prosim_price_diff_#{change}") do
      all.collect {|a| a if a.fetch_prosim_price }.compact.sort_by {|a| a.ArticleNo.to_i }
    end
  end

  # Update all purchase prices from Prosim
  def self.update_all_purchase_prices
    articles = prosim_price_diff
    articles.each {|article| article.save }
    change = File.mtime("db/Pro_d.mdb")
    Rails.cache.delete("prosim_price_diff_#{change}")
    Rails.cache.delete("prosim_sync_#{change}")
    return articles
  end
end
