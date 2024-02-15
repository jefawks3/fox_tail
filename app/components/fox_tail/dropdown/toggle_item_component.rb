# frozen_string_literal: true

class FoxTail::Dropdown::ToggleItemComponent < FoxTail::Dropdown::InputItemComponent
  include_options_from FoxTail::ToggleComponent

  def id
    options[:id] ||= multiple? ? tag_id_for_value(checked_value) : tag_id
  end

  def call
    content_tag :div, input_content, html_attributes
  end

  def input_classes
    classnames super, theme.apply(:checkbox, self)
  end

  def input_content
    render FoxTail::ToggleComponent.new(options.merge(class: input_classes)) do |toggle|
      toggle.with_label(content) if content?
    end
  end
end
