# frozen_string_literal: true

class Flowbite::DismissibleComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController

  has_option :remove, default: false, type: :boolean

  def before_render
    super

    html_attributes[:class] = html_class
  end

  def call
    content_tag :button, content, html_attributes
  end

  def stimulus_controller_options
    {
      remove: remove?,
      dismissing_classes: theme.classname("root.dismissing"),
      dismissed_classes: theme.classname("root.dismissed")
    }
  end

  class << self
    def stimulus_controller_name
      :dismissible
    end
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    def attributes(options = {})
      attributes = super options
      attributes[:data][value_key(:remove)] = options[:remove]
      attributes[:data][classes_key(:dismissing)] = options[:dismissing_classes]
      attributes[:data][classes_key(:dismissed)] = options[:dismissed_classes]
      attributes
    end
  end
end
