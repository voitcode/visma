# Customer Bonus is when a Customer receives a payback based on
# how much they have been billed over a period of time
# This happens either with a bill from the customer to the supplier
# or with a credit note from the supplier to the customer
#
# The CustomerBonusProfile and the CustomerBonusProfileLines defines
# the bonus calculation for Customers that belongs to the profile.
class Visma::CustomerBonusProfile < Visma::Base
  self.table_name += 'CustomerBonusProfile'
  self.primary_key = 'CustomerBonusProfileNo'

  enum TypeOfPeriod: { month: 1, quarter: 2, tri_annual: 3 }

  has_many :customer_bonus_profile_lines, foreign_key: :CustomerBonusProfileNo
  has_many :customers, foreign_key: :CustomerBonusProfileNo
end
