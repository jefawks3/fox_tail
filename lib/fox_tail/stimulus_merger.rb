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
      controllers.map(&:to_s).reject(&:blank?).uniq.join(" ").presence
    end

    def merge_actions(*actions)
      actions.reject(&:blank?).join(" ").presence
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
