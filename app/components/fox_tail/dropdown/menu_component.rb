# frozen_string_literal: true

class FoxTail::Dropdown::MenuComponent < FoxTail::BaseComponent
  renders_many :items, types: {
    item: {
      as: :item,
      renders: lambda { |options = {}|
        options[:theme] = theme.theme :item
        FoxTail::Dropdown::MenuItemComponent.new options
      }
    },
    checkbox: {
      as: :checkbox,
      renders: lambda { |options = {}|
        options[:theme] = theme.theme :input_item
        FoxTail::Dropdown::CheckboxItemComponent.new options
      }
    },
    radio: {
      as: :radio,
      renders: lambda { |options = {}|
        options[:theme] = theme.theme :input_item
        FoxTail::Dropdown::RadioItemComponent.new options
      }
    },
    toggle: {
      as: :toggle,
      renders: lambda { |options = {}|
        options[:theme] = theme.theme :input_item
        FoxTail::Dropdown::ToggleItemComponent.new options
      }
    }
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

  def objectify_options(options)
    super.merge name: name, value: value, multiple: multiple?
  end
end
