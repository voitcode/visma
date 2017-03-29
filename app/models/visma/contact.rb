# Customer contact persons
class Visma::Contact < Visma::Base
  self.table_name += 'Contact'
  self.primary_key = 'ContactNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy

  enum InActiveYesNo: [:active, :inactive]

  belongs_to :customer, foreign_key: :CustomerNo

  validates :ContactNo, :EmailAddress, :MobileTelephone, presence: true

  before_validation :set_primary_key

  # Return the first unused ContactNo
  def self.first_unused_contact_number
    existing = unscoped.pluck(:ContactNo).sort
    numbers = 1..existing.last
    new_number = numbers.detect { |n| !existing.include?(n) }
    new_number || existing.last + 1
  end

  private

  def set_primary_key
    self.ContactNo ||= Visma::Contact.first_unused_contact_number
  end
end
