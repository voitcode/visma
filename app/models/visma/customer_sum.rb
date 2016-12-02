class Visma::CustomerSum < Visma::Base
  self.table_name += 'CustomerSum'
  self.primary_key = 'CustomerNo'

  belongs_to :customer, foreign_key: 'CustomerNo'
end
