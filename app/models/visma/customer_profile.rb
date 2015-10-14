class Visma::CustomerProfile < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerProfile"
  self.primary_key = "CustomerProfileNo"

  include Visma::Timestamp
  include Visma::ChangeBy

  has_many :customers, foreign_key: :CustomerProfileNo

  # => { "CustomerProfileNo" => "Name }
  def self.collection
    a = options.map(&:reverse).flatten
    Hash[*a]
  end

  def self.options
    all.map {|p| [p.Name, p.CustomerProfileNo] }
  end
end
