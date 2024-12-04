# frozen_string_literal: true

class FoxTail::CheckboxComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable
  include FoxTail::Concerns::ControllableFormField

  has_option :color, default: :default
  has_option :size, default: :base
  has_option :value
  has_option :unchecked_value, default: "0"
  has_option :checked_value, default: "1"
  has_option :include_hidden, type: :boolean, default: true
  has_option :multiple, type: :boolean, default: false
  has_option :checked, type: :boolean
  has_option :required, type: :boolean, default: false

  def value
    options[:value] ||= value_from_object
  end

  def checked?
    return !!options[:checked] if options.key? :checked

    case value
    when TrueClass, FalseClass
      value == !!checked_value
    when NilClass
      false
    when String
      value == checked_value
    else
      if value.respond_to?(:include?)
        value.map(&:to_s).include?(checked_value.to_s)
      else
        value.to_i == checked_value.to_i
      end
    end
  end

  def before_render
    super

    if multiple?
      add_default_name_and_id_for_value checked_value
    else
      add_default_name_and_id
    end

    html_attributes[:type] = :checkbox
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    html_attributes[:value] = checked_value
    html_attributes[:checked] = checked?
    html_attributes[:required] = required?
  end

  def call
    capture do
      concat tag.input(**hidden_attributes) if include_hidden?
      concat tag.input(**html_attributes)
    end
  end

  private

  def hidden_attributes
    html_attributes.slice(:name, :disabled, :form)
      .merge!(type: :hidden, value: unchecked_value, autocomplete: "off")
  end
end
