# frozen_string_literal: true

class FoxTail::ToggleComponent < FoxTail::CheckboxComponent
  renders_one :label, lambda { |text| content_tag :span, text, class: theme.apply(:label, self) }

  def before_render
    super

    html_attributes[:class] = theme.apply(:root, self)
  end

  def call
    content_tag :label, container_attributes do
      concat super
      concat content_tag(:div, nil, toggle_attributes)
      concat label if label?
      concat content if content?
    end
  end

  private

  def container_attributes
    { class: classnames(theme.apply(:container, self), html_class) }
  end

  def toggle_attributes
    { class: theme.apply(:toggle, self) }
  end
end
