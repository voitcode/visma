module Visma
  # Change timestamp on article after save
  module ArticleChange
    extend ActiveSupport::Concern

    included do
      after_save :touch_article
    end

    def touch_article
      if a = article
        a.update_attribute(:LastUpdatedBy, 1)
      end
    end
  end
end
