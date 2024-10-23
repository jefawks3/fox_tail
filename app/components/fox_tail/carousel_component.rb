# frozen_string_literal: true

class FoxTail::CarouselComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::HasStimulusController

  renders_many :slides, lambda { |options = {}, &block|
    options[:class] = classnames theme.apply(:slide, self),
      hidden_slide_classes,
      options[:class]

    if use_stimulus?
      options[:data] ||= {}
      options[:data][stimulus_controller.target_key] = :slide
    end

    content_tag :div, options do
      capture(&block)
    end
  }

  has_option :indicators, as: :show_indicators, default: true
  has_option :controls, as: :show_controls, default: true
  has_option :interval
  has_option :position

  def render?
    slides?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def stimulus_controller_options
    {
      position: position,
      interval: interval,
      previous_slide_classes: previous_slide_classes,
      current_slide_classes: current_slide_classes,
      next_slide_classes: next_slide_classes,
      hidden_slide_classes: hidden_slide_classes,
      active_indicator_classes: active_indicator_classes,
      inactive_indicator_classes: inactive_indicator_classes
    }
  end

  private

  def previous_slide_classes
    theme.apply "slide/previous", self
  end

  def current_slide_classes
    theme.apply "slide/current", self
  end

  def next_slide_classes
    theme.apply "slide/next", self
  end

  def hidden_slide_classes
    theme.apply "slide/hidden", self
  end

  def active_indicator_classes
    theme.apply "indicator/active", self
  end

  def inactive_indicator_classes
    theme.apply "indicator/inactive", self
  end

  class StimulusController < FoxTail::StimulusController
    def attributes(options = {})
      attributes = super
      attributes[:data][value_key(:position)] = options[:position]
      attributes[:data][value_key(:interval)] = options[:interval]
      attributes[:data][classes_key(:previous_slide)] = options[:previous_slide_classes]
      attributes[:data][classes_key(:current_slide)] = options[:current_slide_classes]
      attributes[:data][classes_key(:next_slide)] = options[:next_slide_classes]
      attributes[:data][classes_key(:hidden_slide)] = options[:hidden_slide_classes]
      attributes[:data][classes_key(:active_indicator)] = options[:active_indicator_classes]
      attributes[:data][classes_key(:inactive_indicator)] = options[:inactive_indicator_classes]
      attributes
    end
  end
end
