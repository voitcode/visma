class Visma::DiscountGroupCustomer < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "DiscountGroupCustomer"
  self.primary_key = "DiscountGrpCustNo"
end
