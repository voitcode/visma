# Isonor - Isomat custom table
class Visma::ZUsrRuterPrKunde < Visma::Base
  self.table_name += 'ZUsrRuterPrKunde'
  self.primary_key = 'ZUsrRutePrKundeSeqNo'
  belongs_to :customer, foreign_key: :ZUsrCustomerNo
  belongs_to :z_usr_ruter, foreign_key: :ZUsrRuteSeqNo
end
