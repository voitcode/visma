class Visma::Business < Visma::Base
  self.table_name += 'Business'
  self.primary_key = 'BusinessNo'

  include Visma::Timestamp
  include Visma::ChangeBy
end
