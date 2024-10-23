# frozen_string_literal: true

class FoxTail::Timeline::EntryComponent < FoxTail::BaseComponent
  renders_one :visual, types: {
    dot: {
      as: :dot_indicator,
      renders: lambda { |options = {}|
        options[:color] ||= :neutral
        options[:class] = classnames theme.apply(:visual, self),
          theme.apply("visual/dot", self),
          options[:class]

        FoxTail::DotIndicatorComponent.new options
      }
    },
    icon: {
      as: :icon,
      renders: lambda { |icon_or_options = {}, options = {}|
        if icon_or_options.is_a? Hash
          options = icon_or_options
          icon_or_options = "calendar"
        end

        render_icon(options) { |attributes| render FoxTail::IconBaseComponent.new(icon_or_options, attributes) }
      }
    },
    svg: {
      as: :svg,
      renders: lambda { |path, options = {}|
        render_icon(options) { |attributes| render FoxTail::InlineSvgComponent.new(path, attributes) }
      }
    },
    image: {
      as: :image,
      renders: lambda { |source, options = {}|
        container_classes = classnames theme.apply(:visual, self),
          theme.apply("visual/container", self),
          options.delete(:class)

        options[:class] = theme.apply("visual/image", self)

        content_tag :span, class: container_classes do
          image_tag source, options
        end
      }
    }
  }

  has_option :vertical, type: :boolean, default: true

  def render?
    content?
  end

  def before_render
    super

    with_dot_indicator unless visual?
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  private

  def render_icon(options, &block)
    display_options = options.extract! :color
    display_options[:color] ||= :default

    container_classes = classnames theme.apply(:visual, self, display_options),
      theme.apply("visual/container", self, display_options),
      options.delete(:class)

    options[:class] = theme.apply("visual/icon", self, display_options)

    content_tag :span, class: container_classes do
      block.call options, display_options
    end
  end
end
