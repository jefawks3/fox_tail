# frozen_string_literal: true

class Flowbite::IconButtonComponent < Flowbite::ButtonBaseComponent
  renders_many :icons, lambda { |icon, options = {}|
    options[:class] = classnames theme.apply(:icon, self), options[:class]
    Flowbite::IconBaseComponent.new icon, options
  }

  def initialize(icon_or_attributes = {}, html_attributes = {})
    if icon_or_attributes.is_a? Hash
      html_attributes = icon_or_attributes
    else
      with_icon icon_or_attributes
    end

    super(html_attributes)
  end

  def call
    super do
      icons.each { |icon| concat icon }
      concat content_tag(:span, content, class: theme.classname("accessibility.sr_only")) if content?
    end
  end
end
