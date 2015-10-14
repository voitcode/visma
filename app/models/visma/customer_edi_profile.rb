class Visma::CustomerEdiProfile < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CustomerEdiProfile"
  self.primary_key = "EdiProfileNo"

  include Visma::Timestamp
  include Visma::ChangeBy

  belongs_to :edi_provider, primary_key: "EDIProviderNo", foreign_key: "EDIProviderNo", class_name: Visma::EDIProvider
  has_many :edi_transactions, foreign_key: "EDIProfileNo", class_name: Visma::EDITransaction
  has_many :customers, foreign_key: :EdiProfileNo

  # => { "EdiProfileNo" => "Name }
  def self.collection
    a = options.map(&:reverse).flatten
    Hash[*a]
  end

  def self.options
    all.map {|p| [p.Name, p.EdiProfileNo] }
  end
end
