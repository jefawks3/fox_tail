# frozen_string_literal: true

class Flowbite::RadioButtonComponent < Flowbite::BaseComponent
  has_option :color, default: :default
  has_option :size, default: :base

  def before_render
    super

    html_attributes[:type] = :radio
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    tag :input, html_attributes
  end
end
