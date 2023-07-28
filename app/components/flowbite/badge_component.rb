# frozen_string_literal: true

class Flowbite::BadgeComponent < Flowbite::BaseComponent
  attr_reader :size, :color, :url

  renders_one :icon, lambda { |icon, options = {}|
    options[:variant] ||= :mini
    options[:"aria-hidden"] = true
    options[:class] = icon_classes options[:class]
    Flowbite::IconBaseComponent.new icon, **options
  }

  def initialize(size: :base, color: :default, pill: false, border: false, icon_only: false, url: nil, **html_attributes)
    super html_attributes
    @size = size
    @color = color
    @pill = pill
    @border = border
    @icon_only = icon_only
    @url = url
  end

  def url?
    url.present?
  end

  def pill?
    # noinspection RubySimplifyBooleanInspection
    !!@pill
  end

  def border?
    # noinspection RubySimplifyBooleanInspection
    !!@border
  end

  def icon_only?
    # noinspection RubySimplifyBooleanInspection
    !!@icon_only || !content?
  end

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
