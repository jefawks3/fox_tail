# frozen_string_literal: true

class FoxTail::DismissibleComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::HasStimulusController

  has_option :remove, default: false, type: :boolean
  has_option :auto_close, default: false, type: :boolean
  has_option :delay, default: 3000

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, content, html_attributes
  end

  def stimulus_controller_options
    {
      remove: remove?,
      auto_close: auto_close?,
      delay: delay,
      dismissing_classes: theme.apply("root/dismissing", self),
      dismissed_classes: theme.apply("root/dismissed", self)
    }
  end

  class << self
    def stimulus_controller_name
      :dismissible
    end
  end

  class StimulusController < FoxTail::StimulusController
    def attributes(options = {})
      attributes = super options
      attributes[:data][value_key(:remove)] = options[:remove]
      attributes[:data][value_key(:auto_close)] = options[:auto_close]
      attributes[:data][value_key(:delay)] = options[:delay]
      attributes[:data][classes_key(:dismissing)] = options[:dismissing_classes]
      attributes[:data][classes_key(:dismissed)] = options[:dismissed_classes]
      attributes
    end
  end
end
