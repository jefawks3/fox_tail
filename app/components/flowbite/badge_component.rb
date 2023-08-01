# frozen_string_literal: true

class Flowbite::BadgeComponent < Flowbite::BaseComponent
  renders_one :icon, lambda { |icon, options = {}|
    options[:variant] ||= :mini
    options[:"aria-hidden"] = true
    options[:class] = icon_classes options[:class]
    Flowbite::IconBaseComponent.new icon, **options
  }

  has_option :url
  has_option :size, default: :base
  has_option :color, default: :default
  has_option :pill, default: false, type: :boolean
  has_option :border, default: false, type: :boolean
  has_option :icon_only, default: false, type: :boolean

  def call
    content_tag (url? ? :a : :span), html_attributes.merge(href: url, class: root_classes) do
      concat icon if icon?
      concat content_tag(:span, content, class: content_classes) if content?
    end
  end

  private

  def root_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :size, size]),
               theme.classname([:root, :color, color]),
               border? && theme.classname("root.bordered.base"),
               border? && theme.classname([:root, :bordered, :color, color]),
               url? && theme.classname("root.link.base"),
               url? && theme.classname([:root, :link, :color, color]),
               pill? && theme.classname("root.pills"),
               !icon_only? && theme.classname("root.visuals"),
               icon_only? && theme.classname("root.visuals_only.base"),
               icon_only? && theme.classname([:root, :visuals_only, :size, size]),
               html_class
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
