# frozen_string_literal: true

class Flowbite::LinkComponent < Flowbite::BaseComponent
  include Flowbite::StimulusControllerHelper

  attr_reader :url, :color

  def initialize(url, color: :default, disabled: false, controlled: false, **html_attributes)
    @url = url
    @color = color
    @disabled = disabled
    @controlled = controlled
    super(html_attributes)
  end

  def disabled?
    !!@disabled
  end

  def controlled?
    !!@controlled && use_stimulus?
  end

  def before_render
    super

    html_attributes[:class] = root_classes

    if controlled?
      html_attributes[:data] ||= {}
      html_attributes[:data][:controller] = stimulus_controllers html_attributes[:data][:controller],
                                                                 stimulus_controller_identifier

      html_attributes[:data][stimulus_controller.value_key(:disabled)] = disabled?
      html_attributes[:data][stimulus_controller.classes_key(:active)] = active_classes
      html_attributes[:data][stimulus_controller.classes_key(:disabled)] = disabled_classes
    end
  end

  def call
    if disabled? && !controlled?
      content_tag :span, content, html_attributes
    else
      link_to content, url, html_attributes
    end
  end

  private

  def root_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :color, color]),
               disabled? && disabled_classes,
               html_class
  end

  def active_classes
    classnames theme.classname("root.base"), theme.classname([:root, :color, color]), html_class
  end

  def disabled_classes
    classnames theme.classname("root.disabled.base"), theme.classname([:root, :disabled, :color, color])
  end
end
