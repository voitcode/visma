# See Visma::CustomerBonusProfile
#
# CustomerBonusProfileLine defines bonus calculation rules
# for each recurring period in a given year and period.
class Visma::CustomerBonusProfileLine < Visma::Base
  self.table_name += 'CustomerBonusProfileLine'
  self.primary_key = 'SeqNo'

  belongs_to :customer_bonus_profile,
             foreign_key: :CustomerBonusProfileNo
end
