class Visma::SupplierGroup < Visma::Base
  self.table_name += 'SupplierGroup'
  self.primary_key = 'SupplierGrpNo'
  enum InActiveYesNo: [:active, :inactive]
end
