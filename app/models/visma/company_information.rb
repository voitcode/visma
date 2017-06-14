module Visma
  # Information about the licensed company using Visma Global
  class CompanyInformation < Visma::Base
    self.table_name += 'CompanyInformation'
    self.primary_key = 'CompanyNo'

    belongs_to :bank_connection, foreign_key: :BankConNo
  end
end
