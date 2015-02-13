class Visma::ChartererCompany < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "ChartererCompany"
  self.primary_key = "ChartererCompanyNo"
end
