class Visma::CompanyInformation < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "CompanyInformation"
  self.primary_key = "CompanyNo"
end
