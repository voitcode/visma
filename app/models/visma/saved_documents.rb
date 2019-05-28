class Visma::SavedDocuments < Visma::Base
  self.table_name += 'SavedDocuments'
  self.primary_key = 'DocumentsID'
end
