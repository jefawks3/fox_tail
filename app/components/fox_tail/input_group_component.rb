# frozen_string_literal: true

class FoxTail::InputGroupComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable

  has_option :size, default: :base

  renders_many :items, types: {
    input: {
      as: :input,
      renders: lambda { |method_or_options = {}, options = {}|
        if method_or_options.is_a? Hash
          options = method_or_options
        else
          options[:method_name] = method_or_options
        end

        FoxTail::InputComponent.new objectify_options(options)
      }
    },
    select: {
      as: :select,
      renders: lambda { |method_or_options = {}, options = {}|
                 if method_or_options.is_a? Hash
                   options = method_or_options
                 else
                   options[:method_name] = method_or_options
                 end
                 FoxTail::SelectComponent.new objectify_options(options)
               }
    },
    button: {
      as: :button,
      renders: lambda { |method_or_options = {}, options = {}|
                 if method_or_options.is_a? Hash
                   options = method_or_options
                 else
                   options[:method_name] = method_or_options
                 end
                 FoxTail::ButtonComponent.new objectify_options(options)
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

        FoxTail::IconButtonComponent.new icon, objectify_options(options)
      }
    },
    text: {
      as: :text,
      renders: lambda { |text, options = {}|
        addon_component options do
          content_tag :span, text, class: theme.apply("addon/text", self)
        end
      }
    },
    icon: {
      as: :icon,
      renders: lambda { |icon, options = {}|
        options[:class] = classnames theme.apply("addon/visual", self),
          theme.apply("addon/icon", self),
          options[:class]

        addon_component { render FoxTail::IconBaseComponent.new icon, options }
      }
    },
    svg: {
      as: :svg,
      renders: lambda { |path, options = {}|
        options[:class] = classnames theme.apply("addon/visual", self),
          theme.apply("addon/svg", self),
          options[:class]

        addon_component { render FoxTail::InlineSvgComponent.new(path, options) }
      }
    },
    image: {
      as: :image,
      renders: lambda { |path, options = {}|
        image_options = options.extract! :fill
        options[:class] = classnames classnames theme.apply("addon/visual", self),
          theme.apply("addon/image", self, image_options),
          options[:class]

        addon_component(image_options) { image_tag path, options }
      }
    },
    wrapped: {
      as: :item,
      renders: lambda { |&block| FoxTail::WrapperComponent.new(&block) }
    }
  }

  def render?
    items?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, html_attributes do
      items.each_with_index { |item, index| concat render_item(item, index) }
      concat content
    end
  end

  private

  def objectify_options(options)
    options.merge self.options.except(:class, :method_name, :value_array)
  end

  def item_position(index)
    if index.zero?
      :start
    elsif index == items.length - 1
      :end
    else
      :middle
    end
  end

  def addon_component(options = {}, &block)
    FoxTail::WrapperComponent.new class: theme.apply(:addon, self, {fill: options[:fill]}) do |wrapper|
      content_tag :div, wrapper.options do
        capture wrapper, &block
      end
    end
  end

  def render_item(item, index)
    item.with_html_class theme.apply(:item, self, {position: item_position(index)})
    item
  end
end
