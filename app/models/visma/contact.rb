class Visma::Contact < Visma::Base
  self.table_name += 'Contact'
  self.primary_key = 'ContactNo'
  enum InActiveYesNo: [:active, :inactive]

  belongs_to :customer, foreign_key: :CustomerNo
end
