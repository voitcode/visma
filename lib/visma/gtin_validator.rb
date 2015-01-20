#
# GtinValidator validates an ArticleEan based on the uniqueness of a GTIN (EANNo)
# The uniqueness is determined from the UnitType's PackingType value.
# We only accept F, D or T PackingType values for the check, otherwise is an error.
#
class GtinValidator < ActiveModel::Validator
  def validate(article_ean)
    pak = article_ean.unit_type.try(:PackingType)
    e = nil

    units = Visma::UnitType.
      joins(:article_ean).
      where(PackingType: pak).
      where(ArticleEAN: { EANNo: article_ean.EANNo }).
      select(:UnitTypeNo).map(&:UnitTypeNo)

    # Accept the GTIN if it only belongs to this ArticleEan
    unless units.size == 1 and units.first == article_ean.UnitTypeNo

      # Check for valid PackingType
      e = "PackingType is not valid, can't validate GTIN." unless ["F", "D", "T"].include?(pak)

      # If no errors so far, check for uniqueness per [F,D,T]-pak level
      e = "This GTIN is not unique for #{pak+'-PAK' }" if e.nil? and units.size != 0
    end

    article_ean.errors[:base] << e if e
  end
end
