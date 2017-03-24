class Visma::TermsOfDelivery < Visma::Base
  self.table_name += 'TermsOfDelivery'
  self.primary_key = 'TermsOfDeliveryNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy
  has_many :customers, foreign_key: 'TermsOfDeliveryNo'
end
