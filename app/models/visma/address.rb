module Visma
  # Common address methods
  class Address < Visma::Base
    include Visma::Timestamp
    include Visma::CreatedScopes
    include Visma::ChangeBy
    include Visma::PrimaryKey

    scope :active, -> { joins(:customer).where(customer: { InActiveYesNo: 0 }) }
    validate :unique_address_per_customer

    # string used for html select form
    def to_s
      "#{line1}#{' ' + line2 unless line2.blank?}, #{zip} #{city}"
    end

    # comparison
    def ==(other)
      comparable_attributes == other.comparable_attributes
    end

    def eql?(other)
      comparable_attributes == other.comparable_attributes
    end

    def <=>(other)
      comparable_attributes <=> other.comparable_attributes
    end

    # Array of address attributes that matters when comparing
    def comparable_attributes
      [line1, line2, zip, city].map do |n|
        n.to_s.mb_chars.downcase.squish
      end
    end

    # Catch common address attribute names, return correct value
    def method_missing(m, *args, &block)
      att = _real_attribute_name(m)
      raise NoMethodError, "The method :#{m} does not exist" unless att
      if m =~ /=$/
        return self.send "#{att}=", *args
      end
      self.send attribute_aliases[m]
    end

    # Define common names for different address models
    # This method must be defined in the inheriting class
    def attribute_aliases
      raise NotImplementedError, self.class.name
    end

    private

    # Look up the aliased attribute name
    def _real_attribute_name(m)
      att = m.to_s.sub(/=/, '').to_sym
      attribute_aliases[att]
    end
  end
end
