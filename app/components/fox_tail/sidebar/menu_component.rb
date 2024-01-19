# frozen_string_literal: true

class FoxTail::Sidebar::MenuComponent < FoxTail::BaseComponent
  renders_many :items, lambda { |options = {}|
    options[:theme] = theme.theme :menu_item
    FoxTail::Sidebar::MenuItemComponent.new options
  }

  renders_one :menu, lambda { |options = {}|
    options[:theme] = theme.theme :menu
    FoxTail::Sidebar::MenuItemComponent.new options
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
      items.each { |item| concat item }
    end
  end
end
