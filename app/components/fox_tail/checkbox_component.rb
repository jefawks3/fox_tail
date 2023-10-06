# frozen_string_literal: true

class FoxTail::CheckboxComponent < FoxTail::BaseComponent
  has_option :color, default: :default
  has_option :size, default: :base
  has_option :unchecked_value, default: "0"
  has_option :checked_value, default: "1"
  has_option :include_hidden, type: :boolean, default: true

  def before_render
    super

    html_attributes[:type] = :checkbox
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    html_attributes[:value] = checked_value
  end

  def call
    capture do
      concat tag(:input, hidden_attributes) if include_hidden?
      concat tag(:input, html_attributes)
    end
  end

  private

  def hidden_attributes
    html_attributes.slice(:name, :disabled, :form)
                   .merge!(type: :hidden, value: unchecked_value, autocomplete: "off")
  end
end
