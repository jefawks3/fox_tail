# frozen_string_literal: true

class Flowbite::ButtonGroupComponent < Flowbite::BaseComponent
  renders_many :buttons, Flowbite::ButtonComponent

  has_option :size, default: :base
  has_option :pill, default: false, type: :boolean

  def render?
    buttons?
  end

  def call
    classes = classnames theme.classname("root.base"), html_class
    content_tag :div, html_attributes.merge(class: classes) do
      buttons.each_with_index { |btn, index| concat render_button(btn, index) }
    end
  end

  private

  def render_button(button, index)
    position = if index.zero?
                 :start
               elsif index === buttons.length - 1
                 :end
               else
                 :middle
               end

    button.with_size(size).with_pill(pill?)
    button.with_html_class do |c|
      classnames theme.classname("button.base"), theme.classname([:button, :position, position]), c
    end

    render button
  end
end
