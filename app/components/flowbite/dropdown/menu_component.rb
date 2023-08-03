# frozen_string_literal: true

class Flowbite::Dropdown::MenuComponent < Flowbite::BaseComponent
  renders_many :items, Flowbite::Dropdown::MenuItemComponent

  def call
    root_classes = classnames theme.classname("root.base"), html_class
    content_tag :ul, html_attributes.merge(class: root_classes) do
      items.each { |item| concat content_tag(:li, item) }
    end
  end
end
