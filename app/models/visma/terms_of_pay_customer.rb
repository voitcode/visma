class Visma::TermsOfPayCustomer < Visma::Base
  self.table_name += 'TermsOfPayCustomer'
  self.primary_key = 'TermsOfPayCustNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy
  has_many :customers, foreign_key: 'TermsOfPayCustNo'
end
