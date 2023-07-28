# frozen_string_literal: true

class Flowbite::DotIndicatorComponent < Flowbite::BaseComponent
  attr_reader :color

  def initialize(color: :default, animated: false, border: true, **html_attributes)
    @color = color
    @animated = animated
    @border = border
    super(html_attributes)
  end

  def animated?
    !!@animated
  end

  def call
    if animated?
      render_animated_dot
    else
      render_dot
    end
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
