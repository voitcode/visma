class Visma::CustomerGroup < Visma::Base
  self.table_name += 'CustomerGroup'
  self.primary_key = 'CustomerGrpNo'
  enum InActiveYesNo: [:active, :inactive]
end
