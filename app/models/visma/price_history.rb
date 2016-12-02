class Visma::PriceHistory < Visma::Base
  self.table_name += 'PriceHistory'
  self.primary_key = 'UniqueNo'
end
