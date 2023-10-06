# frozen_string_literal: true

class FoxTail::BadgeComponent < FoxTail::BaseComponent
  renders_one :icon, lambda { |icon, options = {}|
    options[:variant] ||= :mini
    options[:"aria-hidden"] = true
    options[:class] = icon_classes options[:class]
    FoxTail::IconBaseComponent.new icon, options
  }

  has_option :url
  has_option :size, default: :base
  has_option :color, default: :default
  has_option :pill, default: false, type: :boolean
  has_option :icon_only, default: false, type: :boolean
  has_option :border, default: false, type: :boolean

  def call
    content_tag (url? ? :a : :span), html_attributes.merge(href: url, class: root_classes) do
      concat icon if icon?
      concat content_tag(:span, content, class: content_classes) if content?
    end
  end

  private

  def root_classes
    classnames theme.apply(:root, self), html_class
  end

  def content_classes
    classnames icon_only? && theme.classname("content.hidden")
  end

  def icon_classes(classes)
    classnames theme.classname("icon.base"),
               theme.classname(["icon", "size", size]),
               classes
  end
end
