# Customer contact persons
class Visma::Contact < Visma::Base
  self.table_name += 'Contact'
  self.primary_key = 'ContactNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy
  include Visma::PrimaryKey

  enum InActiveYesNo: [:active, :inactive]

  belongs_to :customer, foreign_key: :CustomerNo

  validates :ContactNo, :EmailAddress, :MobileTelephone, presence: true
end
