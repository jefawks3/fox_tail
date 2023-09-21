# frozen_string_literal: true

class Flowbite::DotIndicatorComponent < Flowbite::BaseComponent
  has_option :color, default: :default
  has_option :animated, default: false, type: :boolean
  has_option :size, default: :base

  def call
    animated? ? render_animated_dot : render_dot
  end

  private

  def render_dot
    classes = classnames theme.apply(:root, self), theme.apply(:dot, self), html_class
    content_tag :span, nil, html_attributes.merge(class: classes)
  end

  def render_animated_dot
    container_classes = classnames theme.apply(:root, self),
                                   theme.apply(:container, self),
                                   html_class

    dot_classes = classnames theme.apply(:root, self), theme.apply(:dot, self)
    animated_classes = classnames dot_classes, theme.apply("dot/animation", self)

    content_tag :span, html_attributes.merge(class: container_classes) do
      concat content_tag(:span, nil, class: animated_classes)
      concat content_tag(:span, nil, class: dot_classes)
    end
  end
end
