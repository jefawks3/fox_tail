# frozen_string_literal: true

class Flowbite::ButtonGroupComponent < Flowbite::BaseComponent
  renders_many :buttons, Flowbite::ButtonComponent

  has_option :size, default: :base
  has_option :pill, default: false, type: :boolean

  def render?
    buttons?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, html_attributes do
      buttons.each_with_index { |btn, index| concat render_button(btn, index) }
    end
  end

  private

  def button_position(index)
    if index.zero?
      :start
    elsif index === buttons.length - 1
      :end
    else
      :middle
    end
  end

  def render_button(button, index)
    classes = classnames theme.apply(:button, { position: button_position(index) })
    button.with_size size
    button.with_pill pill?
    button.with_html_class classes
    button
  end
end
