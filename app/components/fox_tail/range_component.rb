# frozen_string_literal: true

class FoxTail::RangeComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable

  has_option :disabled, type: :boolean, default: false
  has_option :size, default: :base
  has_option :in, as: :range
  has_option :within, as: :within_range

  def before_render
    super

    add_default_name_and_id
    html_attributes[:type] = :range
    html_attributes[:value] ||= value_before_type_cast
    html_attributes[:disabled] = disabled?
    html_attributes[:class] = classnames theme.apply(:root, self), html_class

    range = self.range || within_range
    html_attributes.update("min" => range.min, "max" => range.max) if range
  end

  def call
    tag.input(html_attributes)
  end
end
