# the post office table
class Visma::PostOffice < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG['table_name_prefix']
  self.table_name += 'PostOffice'
  self.primary_key = 'PostCode'
end
