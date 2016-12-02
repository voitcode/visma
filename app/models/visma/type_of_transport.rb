class Visma::TypeOfTransport < Visma::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "TypeOfTransport"
  self.primary_key = "TypeOfTransportNo"
end
