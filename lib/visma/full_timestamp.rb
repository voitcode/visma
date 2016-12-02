module Visma
  # Use all Visma-compatbile timestamp fields
  module FullTimestamp
    include Visma::Timestamp
    include Visma::CreatedScopes
    include Visma::ChangeBy
  end
end
