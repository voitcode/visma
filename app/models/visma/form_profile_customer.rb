class Visma::FormProfileCustomer < Visma::Base
  self.table_name += 'FormProfileCustomer'
  self.primary_key = 'FormProfileCustNo'

  include Visma::Timestamp
  include Visma::ChangeBy

  has_many :customers, foreign_key: 'FormProfileCustNo'

  # => { "FormProfileCustNo" => "Name }
  def self.collection
    a = options.map(&:reverse).flatten
    Hash[*a]
  end

  def self.options
    all.map { |p| [p.Name, p.FormProfileCustNo] }
  end
end
