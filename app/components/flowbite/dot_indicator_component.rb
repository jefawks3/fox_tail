# frozen_string_literal: true

class Flowbite::DotIndicatorComponent < Flowbite::BaseComponent
  has_option :color, default: :default
  has_option :animated, default: false, type: :boolean

  def call
    animated? ? render_animated_dot : render_dot
  end

  private

  def render_dot
    classes = classnames theme.classname("root.base"), theme.classname([:root, :color, color]), html_class
    content_tag :span, nil, html_attributes.merge(class: classes)
  end

  def render_animated_dot
    container_classes = classnames theme.classname("root.base"),
                                   theme.classname("container.base"),
                                   html_class

    dot_classes = classnames theme.classname("root.base"),
                             theme.classname([:root, :color, color]),
                             theme.classname("animated.dot")

    animated_classes = classnames dot_classes, theme.classname("animated.base")

    content_tag :span, html_attributes.merge(class: container_classes) do
      concat content_tag(:span, nil, class: animated_classes)
      concat content_tag(:span, nil, class: dot_classes)
    end
  end
end
