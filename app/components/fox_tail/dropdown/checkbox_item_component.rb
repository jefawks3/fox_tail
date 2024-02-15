# frozen_string_literal: true

class FoxTail::Dropdown::CheckboxItemComponent < FoxTail::Dropdown::InputItemComponent
  include_options_from FoxTail::CheckboxComponent

  def id
    options[:id] ||= multiple? ? tag_id_for_value(checked_value) : tag_id
  end

  def input_classes
    classnames super, theme.apply(:checkbox, self)
  end

  def input_content
    render FoxTail::CheckboxComponent.new(options.merge(class: input_classes))
  end
end
