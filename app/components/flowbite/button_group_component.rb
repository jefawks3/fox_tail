# frozen_string_literal: true

class Flowbite::ButtonGroupComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::Formable

  renders_many :buttons, types: {
    button: {
      as: :button,
      renders: lambda { |method_or_options = {}, options = {}|
        if method_or_options.is_a? Hash
          options = method_or_options
        else
          options[:method_name] = method_or_options
        end

        Flowbite::ButtonComponent.new objectify_component_options(options)
      }
    },
    icon_button: {
      as: :icon_button,
      renders: lambda { |icon_or_method, *args|
        options = args.extract_options!
        icon = icon_or_method

        unless args.empty?
          icon = args.first
          options[:method_name] = icon_or_method
        end

        Flowbite::IconButtonComponent.new icon, objectify_component_options(options)
      }
    }
  }

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

  def objectify_component_options(options)
    options.merge self.options.except(:class, :method_name, :value_array)
  end

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
    button.with_html_class theme.apply(:button, self, { position: button_position(index) })
    button
  end
end
