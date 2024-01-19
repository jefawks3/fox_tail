# frozen_string_literal: true

class FoxTail::IconButtonComponent < FoxTail::ButtonBaseComponent
  renders_many :icons, lambda { |icon, options = {}|
    options[:class] = classnames theme.apply(:icon, self), options[:class]
    FoxTail::IconBaseComponent.new icon, options
  }

  def initialize(icon_or_attributes = {}, html_attributes = {})
    if icon_or_attributes.is_a? Hash
      html_attributes = icon_or_attributes
      icon_or_attributes = nil
    end

    super(html_attributes)

    with_icon icon_or_attributes if icon_or_attributes.present?
  end

  def call
    super do
      icons.each { |icon| concat icon }
      concat indicator if indicator?

      if content? || i18n_content.present?
        concat content_tag(:span, retrieve_content, class: theme.apply(:content, self))
      end
    end
  end
end
