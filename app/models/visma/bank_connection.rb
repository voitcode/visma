module Visma
  # The financial institutions used at the Company
  class BankConnection < Visma::Base
    self.table_name += 'BankConnection'
    self.primary_key = 'BankConNo'
  end
end
