# the post office table
class Visma::PostOffice < Visma::Base
  self.table_name += 'PostOffice'
  self.primary_key = 'PostCode'
end
