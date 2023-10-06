# frozen_string_literal: true

class FoxTail::ColorThemeTriggerComponent < FoxTail::TriggerBaseComponent
  has_option :action

  def initialize(html_attributes = {})
    super html_attributes.delete(:id), nil, html_attributes
  end

  def stimulus_controller_options
    super.merge action: action
  end

  class << self
    def stimulus_controller_name
      :color_theme
    end
  end

  class StimulusController < FoxTail::StimulusController
    def attributes(options = {})
      controller_options = options.extract! :key, :storage, :default_theme, :domain
      controller_options.reverse_merge! FoxTail::Base.fox_tail_config.color_theme
      attributes = super options
      attributes[:data][value_key(:key)] = controller_options[:key]
      attributes[:data][value_key(:storage)] = controller_options[:storage]
      attributes[:data][value_key(:default_theme)] = controller_options[:default_theme]
      attributes[:data][value_key(:domain)] = controller_options[:domain]
      attributes[:data][:action] = action(options[:action], event: options[:trigger_type]) if options[:action].present?
      attributes
    end

    def toggle_action(event: nil)
      action :toggle, event: event
    end

    def set_dark_mode_action(event: nil)
      action "setDarkMode", event: event
    end

    def set_light_mode_action(event: nil)
      action "setLightMode", event: event
    end

    def set_preferred_action(event: nil)
      action "setPreferred", event: event
    end
  end
end
