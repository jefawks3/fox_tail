# frozen_string_literal: true

class Flowbite::ButtonBaseComponent < Flowbite::BaseComponent
  include Flowbite::StimulusControllerHelper

  attr_reader :url, :variant, :color, :size

  def initialize(url: nil, variant: :solid, size: :base, color: :default, disabled: false, pill: false, controlled: false, **html_attributes)
    @variant = variant
    @color = color
    @size = size
    @url = url
    @disabled = disabled
    @pill = pill
    @controlled = controlled

    super(html_attributes)
  end

  def url?
    url.present?
  end

  def disabled?
    !!@disabled
  end

  def pill?
    !!@pill
  end

  def controlled?
    !!@controlled && use_stimulus?
  end

  def before_render
    super

    html_attributes[:class] = root_classes
    html_attributes[:role] ||= :button
    html_attributes[:href] = url if url?
    html_attributes[:type] ||= :button unless url?
    html_attributes[:disabled] = true if disabled? && !url?

    if controlled?
      html_attributes[:data] ||= {}
      html_attributes[:data][:controller] = stimulus_controllers html_attributes[:data][:controller],
                                                                 stimulus_controller_identifier

      html_attributes[:data][stimulus_controller.value_key(:disabled)] = disabled?
      html_attributes[:data][stimulus_controller.value_key(:loading)] = loading? if loadable?
      html_attributes[:data][stimulus_controller.classes_key(:active)] = active_classes
      html_attributes[:data][stimulus_controller.classes_key(:disabled)] = disabled_classes
    end
  end

  def call(&block)
    content_tag tag_name, block ? capture(&block) : content, html_attributes
  end

  protected

  def root_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :size, size]),
               theme.classname([:root, variant, :base]),
               theme.classname([:root, variant, color]),
               pill? && theme.classname("root.pill"),
               (disabled? || loading?) && disabled_classes,
               block_given? && yield,
               html_class
  end

  def active_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :size, size]),
               theme.classname([:root, variant, :base]),
               theme.classname([:root, variant, color]),
               pill? && theme.classname("root.pill"),
               block_given? && yield,
               html_class
  end

  def disabled_classes
    classnames theme.classname("root.disabled.base"),
               theme.classname([:root, :disabled, variant, :base]),
               theme.classname([:root, :disabled, variant, color]),
               block_given? && yield
  end

  private

  def tag_name
    if disabled? && !controlled? && url?
      :span
    elsif url?
      :a
    else
      :button
    end
  end

  class << self
    def stimulus_controller_name
      :button
    end
  end
end
