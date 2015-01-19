module Visma
  module ArticleChange
    extend ActiveSupport::Concern

    included do
      after_save :touch_article
    end

    # Change timestamp on article
    def touch_article
      article.LastUpdate = Time.now
      article.save
    end
  end
end

