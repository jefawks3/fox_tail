# frozen_string_literal: true

class FoxTail::Dropdown::RadioItemComponent < FoxTail::Dropdown::InputItemComponent
  include_options_from FoxTail::RadioButtonComponent

  def input_classes
    classnames super, theme.apply(:radio, self)
  end

  def input_content
    render FoxTail::RadioButtonComponent.new(options.merge(class: input_classes))
  end
end
