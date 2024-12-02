# frozen_string_literal: true

module FoxTail
  class StimulusBuilder
    EVENT_ALIASES = {
      hover_in: %w[mouseenter focus].freeze,
      hover_out: %w[mouseleave blur].freeze
    }.freeze

    attr_reader :identifier, :html_attributes

    def initialize(identifier, html_attributes, options = {})
      @identifier = format_identifier identifier
      @html_attributes = html_attributes
      register_values options[:values]
      register_classes options[:classes]
      register_outlets options[:outlets]
      register_params options[:params]
      register_actions options[:actions]
    end

    def register_controller
      html_attributes.merge_stimulus_controllers!(identifier)
    end

    def target_attribute_name
      key :target
    end

    def with_value(name, value)
      html_attributes.merge_stimulus! key(name, :value) => value
    end

    def with_class(name, value)
      html_attributes.merge_stimulus! key(name, :class) => value
    end

    def with_outlet(name, value)
      html_attributes.merge_stimulus! key(format_identifier(name), :outlet) => value
    end

    def with_param(name, value)
      html_attributes.merge_stimulus! param_attribute_name(name) => value
    end

    def param_attribute_name(name)
      key name, :param
    end

    def with_action(method, on: nil, at: nil)
      html_attributes.merge_stimulus_actions! action(method, on: on, at: at)
    end

    def action(method, on: nil, at: nil)
      controller_method = "#{identifier}##{method}"

      if on.nil?
        controller_method
      else
        events = Array(on).map { |event| EVENT_ALIASES.fetch(event, event) }.flatten

        controller_actions = events.each_with_object([]) do |event, actions|
          if event.nil?
            actions << controller_method
          else
            event = "#{event}@#{event}" if at.present?
            actions << "#{event}->#{controller_method}"
          end
        end

        controller_actions.join " "
      end
    end

    def event(event)
      "#{identifier}:#{event}"
    end

    private

    delegate :format_identifier, to: :class

    def key(*parts)
      key = parts.map(&:to_s)
      key.unshift identifier
      key.join("_").gsub("-", "_").to_sym
    end

    def register_values(values)
      return if values.blank?

      values.each { |name, value| with_value name, value }
    end

    def register_classes(classes)
      return if classes.blank?

      classes.each { |name, value| with_class name, value }
    end

    def register_outlets(outlets)
      return if outlets.blank?

      outlets.each { |name, value| with_outlet name, value }
    end

    def register_params(params)
      return if params.blank?

      params.each { |name, value| with_param name, value }
    end

    def register_actions(actions)
      return if actions.blank?

      actions.each do |method, value|
        if value.is_a?(Hash)
          with_action method, **value
        else
          with_action method, on: value
        end
      end
    end

    class << self
      def format_identifier(identifier)
        Array(identifier).map { |i| i.to_s.gsub("_", "-") }.join("--")
      end
    end
  end
end
