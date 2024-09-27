# frozen_string_literal: true

module FoxTail
  module IconSets
    class Base
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def path(icon, variant: :solid)
        raise NotImplementedError
      end

      def root_path
        raise NotImplementedError
      end

      protected

      def normalize_icon_name(name)
        name.to_s.gsub("_", "-")
      end

      def __raise_invalid_variant(variant)
        raise FoxTail::InvalidIconSetVariant.new(name, variant)
      end
    end
  end
end
