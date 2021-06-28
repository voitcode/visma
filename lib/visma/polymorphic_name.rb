module Visma
  # Polymorphic class name without STI
  module PolymorphicName
    extend ActiveSupport::Concern

    included do
      def self.polymorphic_name
        name
      end
    end
  end
end
