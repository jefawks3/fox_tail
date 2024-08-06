# frozen_string_literal: true

class FoxTail::Sidebar::MenuComponent < FoxTail::BaseComponent
  renders_one :title

  renders_many :items, lambda { |options = {}|
    options[:theme] = theme.theme :menu_item
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
    content_tag :div, class: theme.apply(:container, self) do
      concat render_title if title?
      concat render_menu
    end
  end

  private

  def render_title
    content_tag :h3, title, class: theme.apply(:title, self)
  end

  def render_menu
    content_tag :ul, html_attributes do
      items.each { |item| concat item }
    end
  end
end
