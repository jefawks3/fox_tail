# frozen_string_literal: true

module Flowbite
  module ViewComponents
    class StimulusMerger
      def merge_attributes!(attributes, *other_attributes)
        attributes[:data] ||= {}
        other_attributes.each { |attr| merge_stimulus_attributes attributes, attr }
        attributes
      end

      def merge_attributes(attributes, *other_attributes)
        merge_attributes!(attributes.deep_dup, *other_attributes)
      end

      def merge_controllers(*controllers)
        controllers.map(&:to_s).reject(&:blank?).uniq.join(" ").to_sym
      end

      private

      def merge_stimulus_attributes(source, attributes)
        attributes[:data] ||= {}
        controllers = merge_controllers source[:data].delete(:controller), attributes[:data].delete(:controller)
        source[:data][:controller] = controllers
        source.deep_merge! attributes
      end
    end
  end
end
