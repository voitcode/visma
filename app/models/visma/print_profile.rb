class Visma::PrintProfile < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "PrintProfile"
  self.primary_key = "PrintProfileNo"

  include Visma::Timestamp
  include Visma::ChangeBy

  has_many :customers, foreign_key: "PrintProfileNo"

  # => { "Name" => "PrintProfileNo"}
  def self.collection
    a = all.map {|p| [p.Name, p.PrintProfileNo] }.flatten
    Hash[*a]
  end
end
