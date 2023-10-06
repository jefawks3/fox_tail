# frozen_string_literal: true

class FoxTail::ButtonGroupComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable

  renders_many :buttons, types: {
    button: {
      as: :button,
      renders: lambda { |method_or_options = {}, options = {}|
        if method_or_options.is_a? Hash
          options = method_or_options
        else
          options[:method_name] = method_or_options
        end

        FoxTail::ButtonComponent.new button_component_options(options)
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

        FoxTail::IconButtonComponent.new icon, button_component_options(options)
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
      buttons.each { |btn| concat btn }
    end
  end

  private

  def button_component_options(options)
    options = objectify_component_options options
    options[:class] = classnames theme.apply(:button, self), options[:class]
    options
  end

  def objectify_component_options(options)
    options.merge self.options.except(:class, :method_name, :value_array)
  end
end
