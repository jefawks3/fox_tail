# frozen_string_literal: true

module FoxTail
  class StimulusManager
    attr_reader :html_attributes

    def initialize(html_attributes)
      @html_attributes = html_attributes
      @stimulus_builders = ActiveSupport::HashWithIndifferentAccess.new
    end

    def register(identifier, options = {})
      identifier = FoxTail::StimulusBuilder.format_identifier(identifier)
      raise KeyError, "Stimulus builder '#{identifier}' already registered" if registered?(identifier)

      @stimulus_builders[identifier] = with(identifier, options).tap { |builder| builder.register_controller }
    end

    alias_method :<<, :register
    alias_method :[]=, :register

    def with(identifier, options = {})
      FoxTail::StimulusBuilder.new(identifier, @html_attributes, options)
    end

    def [](identifier)
      @stimulus_builders[identifier]
    end

    def registered?(identifier)
      identifier = FoxTail::StimulusBuilder.format_identifier(identifier)
      @stimulus_builders.key?(identifier)
    end

    alias_method :key?, :registered?

    delegate :keys, :values, :for_each, to: :@stimulus_builders
  end
end
