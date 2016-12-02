class Visma::StorageType < Visma::Base
  self.table_name += 'StorageType'
  self.primary_key = 'StorageTypeNo'
  include Visma::Timestamp
  include Visma::CreatedScopes
  include Visma::ChangeBy

  belongs_to :article, foreign_key: :StorageTypeNo, primary_key: :StorageTypeNo
end
