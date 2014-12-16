# Isonor - Isomat custom table
class Visma::ZUsrRuterPrKunde < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "ZUsrRuterPrKunde"
  self.primary_key = "ZUsrRutePrKundeSeqNo"

  belongs_to :customer, foreign_key: :ZUsrCustomerNo
  belongs_to :z_usr_ruter, foreign_key: :ZUsrRuteSeqNo
end
