# frozen_string_literal: true

class FoxTail::CarouselComponent < FoxTail::BaseComponent
  renders_many :slides, lambda { |options = {}, &block|
    options[:class] = classnames theme.apply(:slide, self),
      hidden_slide_classes,
      options[:class]

    options[:data] ||= {}
    options[:data][carousel_controller.target_attribute_name] = :slide

    content_tag :div, options do
      capture(&block)
    end
  }

  has_option :indicators, as: :show_indicators, default: true
  has_option :controls, as: :show_controls, default: true
  has_option :interval
  has_option :position

  stimulated_with [:fox_tail, :carousel], as: :carousel do |controller|
    controller.with_value :position, position
    controller.with_value :interval, interval
    controller.with_class :previous_slide, previous_slide_classes
    controller.with_class :current_slide, current_slide_classes
    controller.with_class :next_slide, next_slide_classes
    controller.with_class :hidden_slide, hidden_slide_classes
    controller.with_class :active_indicator, active_indicator_classes
    controller.with_class :inactive_indicator, inactive_indicator_classes
  end

  def render?
    slides?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
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
end
