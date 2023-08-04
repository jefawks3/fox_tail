# frozen_string_literal: true

module Flowbite
  module ViewComponents
    class Controller
      attr_reader :identifier

      def initialize(identifier, config: nil)
        @identifier = format_identifier identifier
        @config = config
      end

      def config
        @config ||= Flowbite::ViewComponents::Base.flowbite_config
      end

      def attributes(options = {})
        raise NotImplementedError
      end

      def merge(attributes, options = {})
        merge! attributes.deep_dup, options
      end

      def merge!(attributes, options = {})
        attributes.merge! self.attributes(options)
      end

      def to_sym
        identifier.gsub("-", "_").to_sym
      end

      def to_s
        identifier
      end

      protected

      def format_identifier(name)
        name.to_s.gsub "_", "-"
      end

      def key(*parts)
        options = parts.extract_options!
        key = parts.map { |p| format_identifier p }

        if options[:raw]
          ([:data] + key).join("-").gsub("_", "-").to_sym
        else
          key.join("_").gsub("-", "_").to_sym
        end
      end
    end
  end
end
