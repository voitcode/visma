# Isonor - Isomat custom table
class Visma::ZUsrRuter < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "ZUsrRuter"
  self.primary_key = "ZUsrRuteSeqNo"

  has_many :z_usr_ruter_pr_kunde, foreign_key: :ZUsrRuteSeqNo
  has_many :customer, through: :z_usr_ruter_pr_kunde

  belongs_to :charterer_company, foreign_key: :ZUsrChartererCompanyNo, primary_key: :ChartererCompanyNo
end
