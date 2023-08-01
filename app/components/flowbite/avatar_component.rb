# frozen_string_literal: true

class Flowbite::AvatarComponent < Flowbite::BaseComponent
  renders_one :dot, lambda { |position: :top_right, **options|
    options[:class] = classnames theme.classname("dot.base"),
                                 theme.classname([:dot, :position, position]),
                                 options[:class]

    Flowbite::DotIndicatorComponent.new(**options)
  }

  has_option :src
  has_option :icon
  has_option :text
  has_option :size, default: :base
  has_option :rounded, type: :boolean, default: false
  has_option :border, type: :boolean, default: false

  def call
    visual = render_visual

    if dot?
      content_tag :div, class: theme.classname("dot.container") do
        concat dot
        concat visual
      end
    else
      visual
    end
  end

  private

  def root_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :size, size]),
               rounded? && theme.classname("root.rounded"),
               border? && theme.classname("root.border.base"),
               border? && theme.classname([:root, :border, :color, @border.is_a?(TrueClass) ? :default : @border]),
               !src? && theme.classname("root.background"),
               (icon? || text?) && theme.classname("root.visual"),
               text? && theme.classname("root.text"),
               html_class
  end

  def label_classes
    classnames theme.classname("label.base")
  end

  def render_visual
    if src?
      render_image
    elsif icon?
      render_icon
    elsif text?
      render_text
    else
      render_blank
    end
  end

  def render_image
    image_tag src, html_attributes.merge(class: root_classes)
  end

  def render_icon
    icon_classes = classnames theme.classname("icon.base"), theme.classname([:icon, :size, size])
    label = html_attributes[:alt]

    content_tag :div, html_attributes.except(:alt).merge(class: root_classes) do
      concat render(Flowbite::IconBaseComponent.new(icon, class: icon_classes))
      concat content_tag(:span, label, class: label_classes) if label.present?
    end
  end

  def render_text
    label = html_attributes[:alt]
    text_classes = classnames theme.classname("text.base"), theme.classname([:text, :size, size])

    content_tag :div, html_attributes.except(:alt).merge(class: root_classes) do
      concat content_tag(:span, text, class: text_classes)
      concat content_tag(:span, label, class: label_classes) if label.present?
    end
  end

  def render_blank
    label = html_attributes[:alt]

    content_tag :div, html_attributes.except(:alt).merge(class: root_classes) do
      content_tag(:span, label, class: label_classes) if label.present?
    end
  end
end
