module Visma
  # Common methods for Visma models
  class Base < ActiveRecord::Base
    establish_connection("visma_#{Rails.env}".to_sym)
    self.table_name = VISMA_CONFIG['table_name_prefix']
  end
end
