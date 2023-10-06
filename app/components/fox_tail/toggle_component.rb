# frozen_string_literal: true

class FoxTail::ToggleComponent < FoxTail::BaseComponent
  has_option :size, default: :base
  has_option :color, default: :default

  renders_one :label, lambda { |text| content_tag :span, text, class: theme.apply(:label, self) }

  def before_render
    super

    html_attributes[:type]
  end

  def call
    content_tag :label, container_attributes do
      concat content_tag(:input, nil, input_attributes)
      concat content_tag(:div, nil, toggle_attributes)
      concat label if label?
    end
  end

  private

  def container_attributes
    { class: classnames(theme.apply(:container, self), html_class) }
  end

  def input_attributes
    html_attributes.merge type: :checkbox, class: theme.apply(:root, self)
  end

  def toggle_attributes
    { class: theme.apply(:toggle, self) }
  end
end
