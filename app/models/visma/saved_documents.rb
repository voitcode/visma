class Visma::SavedDocuments < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG['table_name_prefix']
  self.table_name += 'SavedDocuments'
  self.primary_key = 'DocumentsID'
end
