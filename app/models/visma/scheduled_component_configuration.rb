class Visma::ScheduledComponentConfiguration < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "ScheduledComponentConfiguration"
  # Check db/visma_schema.rb for primary key, delete and adjust as needed
  #self.primary_key = "ScheduledComponentConfigurationNo"
  #self.primary_key = "UniqueNo"
end