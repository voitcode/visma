class Visma::CustomerEdiProfile < Visma::Base
  self.table_name += 'CustomerEdiProfile'
  self.primary_key = 'EdiProfileNo'

  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :edi_provider,
             primary_key: 'EDIProviderNo',
             foreign_key: 'EDIProviderNo',
             class_name: 'Visma::EdiProvider'
  has_many :edi_transactions,
           foreign_key: 'EDIProfileNo',
           class_name: 'Visma::EdiTransaction'
  has_many :customers, foreign_key: :EdiProfileNo

  # => { "EdiProfileNo" => "Name }
  def self.collection
    a = options.map(&:reverse).flatten
    Hash[*a]
  end

  def self.options
    all.map { |p| [p.Name, p.EdiProfileNo] }
  end
end
