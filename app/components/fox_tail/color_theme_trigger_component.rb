# frozen_string_literal: true

class FoxTail::ColorThemeTriggerComponent < FoxTail::TriggerBaseComponent
  ACTIONS = {
    toggle: {toggle: :click}.freeze,
    set_dark_mode: {setDarkMode: :click}.freeze,
    set_light_mode: {setLightMode: :click}.freeze,
    set_preferred: {setPreferred: :click}.freeze
  }.freeze

  has_option :trigger_type, default: :toggle
  has_option :key
  has_option :storage
  has_option :default_theme
  has_option :domain

  def initialize(html_attributes = {})
    super(nil, self.class.default_options.merge(html_attributes))
  end

  def identifier
    [:fox_tail, :color_theme]
  end

  def before_render
    super

    trigger_controller.with_value :key, key if key?
    trigger_controller.with_value :storage, storage if storage?
    trigger_controller.with_value :default_theme, default_theme if default_theme?
    trigger_controller.with_value :domain, domain if domain?

    ACTIONS[trigger_type&.to_sym]&.each do |method, event|
      trigger_controller.with_action method, on: event
    end
  end
end
