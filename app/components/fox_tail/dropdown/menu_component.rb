# frozen_string_literal: true

class FoxTail::Dropdown::MenuComponent < FoxTail::BaseComponent
  renders_many :items, lambda { |options = {}|
    options[:theme] = theme.theme :item
    FoxTail::Dropdown::MenuItemComponent.new options
  }

  def render?
    items?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :ul, html_attributes do
      items.each { |item| concat content_tag(:li, item) }
    end
  end
end
