# frozen_string_literal: true

module Flowbite
  module ViewComponents
    class StimulusController
      attr_reader :identifier

      def initialize(identifier)
        @identifier = format_identifier identifier
      end

      def target_key(raw: false)
        key :target, raw: raw
      end

      def outlet_key(raw: false)
        key :outlet, raw: raw
      end

      def value_key(name, raw: false)
        key name, :value, raw: raw
      end

      def classes_key(name, raw: false)
        key name, :class, raw: raw
      end

      def to_sym
        identifier.gsub("-", "_").to_sym
      end

      def to_s
        identifier
      end

      private

      def format_identifier(name)
        name.to_s.gsub "_", "-"
      end

      def key(*parts)
        options = parts.extract_options!
        formatted_parts = parts.map { |p| format_identifier p }
        key = [identifier] + formatted_parts

        if options[:raw]
          ([:data] + key).join("-").gsub("_", "-").to_sym
        else
          key.join("_").gsub("-", "_").to_sym
        end
      end
    end
  end
end
