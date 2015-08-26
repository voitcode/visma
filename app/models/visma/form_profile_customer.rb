class Visma::FormProfileCustomer < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = VISMA_CONFIG["table_name_prefix"]
  self.table_name += "FormProfileCustomer"
  self.primary_key = "FormProfileCustNo"

  has_many :customers, foreign_key: "FormProfileCustNo"
end
