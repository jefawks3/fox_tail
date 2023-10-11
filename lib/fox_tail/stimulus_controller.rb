# frozen_string_literal: true

module FoxTail
  class StimulusController
    delegate :stimulus_merger, to: :config

    attr_reader :identifier

    def initialize(identifier, config: nil)
      @identifier = format_identifier identifier
      @config = config
    end

    def config
      @config ||= FoxTail::Config.current
    end

    def attributes(_options = {})
      {
        data: { controller: identifier }
      }
    end

    def target_key(raw: false)
      key :target, raw: raw
    end

    def outlet_key(name, raw: false)
      key name, :outlet, raw: raw
    end

    def value_key(name, raw: false)
      key name, :value, raw: raw
    end

    def classes_key(name, raw: false)
      key name, :class, raw: raw
    end

    def merge(attributes, options = {})
      merge! attributes.deep_dup, options
    end

    def merge!(attributes, options = {})
      stimulus_merger.merge_attributes! attributes, self.attributes(options)
    end

    def action(method_name, event: nil)
      action = "#{identifier}##{method_name}"
      event && event.to_sym != :click ? "#{event}->#{action}" : action
    end

    def event(event_name)
      "#{identifier}:#{event_name}"
    end

    def build_actions(actions)
      return nil if actions.blank?

      formatted_actions = actions.each_with_object([]) do |(method_name, events), results|
        Array(events).each { |event| results.push( action(method_name, event: event)) }
      end

      stimulus_merger.merge_actions(*formatted_actions)
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
      key.unshift identifier

      if options[:raw]
        key.unshift :data
        key.join("-").gsub("_", "-").to_sym
      else
        key.join("_").gsub("-", "_").to_sym
      end
    end
  end
end
