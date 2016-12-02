class Visma::PrintProfile < Visma::Base
  self.table_name += 'PrintProfile'
  self.primary_key = 'PrintProfileNo'

  include Visma::Timestamp
  include Visma::ChangeBy

  has_many :customers, foreign_key: 'PrintProfileNo'

  # => { "PrintProfileNo" => "Name }
  def self.collection
    a = options.map(&:reverse).flatten
    Hash[*a]
  end

  def self.options
    all.map { |p| [p.Name, p.PrintProfileNo] }
  end
end
