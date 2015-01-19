module Visma
  module ArticleChange
    extend ActiveSupport::Concern

    included do
      after_save :touch_article
    end

    # Change timestamp on article
    def touch_article
      if a = self.article
        a.update_attribute(:LastUpdatedBy, 1)
      end
    end
  end
end

