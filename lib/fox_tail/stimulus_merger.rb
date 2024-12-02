# frozen_string_literal: true

module FoxTail
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
      normalize = controllers.flatten.each_with_object({}) do |controller, result|
        next if controller.blank?

        controller.split(" ").each { |identifier| result[identifier] = true }
      end

      normalize.keys.join(" ").presence
    end

    def merge_actions(*actions)
      actions.flatten.select(&:present?).uniq.join(" ").presence
    end

    def merge(*hashes, &block)
      hashes.flatten.compact.each_with_object({}.with_indifferent_access) do |hash, result|
        hash = hash.deep_dup.with_indifferent_access
        result[:controller] = merge_controllers(result[:controller], hash.delete(:controller))
        result[:action] = merge_actions(result[:action], hash.delete(:action))
        result.merge!(hash, &block)
      end
    end

    private

    def merge_stimulus_attributes(source, attributes)
      attributes[:data] ||= {}
      controllers = merge_controllers source[:data].delete(:controller), attributes[:data].delete(:controller)
      actions = merge_actions source[:data].delete(:action), attributes[:data].delete(:action)
      source[:data][:controller] = controllers
      source[:data][:action] = actions
      source.deep_merge! attributes
    end
  end
end
