# frozen_string_literal: true

class FoxTail::BreadcrumbComponent < FoxTail::BaseComponent
  renders_one :separator, types: {
    icon: lambda { |icon, options = {}|
      options[:class] = classnames(
        theme.apply(:separator, self),
        theme.apply("separator/icon", self),
        options[:class]
      )

      FoxTail::IconBaseComponent.new icon, options
    },
    text: lambda { |text, options = {}|
      options[:class] = classnames(
        theme.apply(:separator, self),
        theme.apply("separator/text", self),
        options[:class]
      )

      content_tag :span, text, options
    }
  }

  renders_many :items, types: {
    link: lambda { |url, options = {}, &block|
      options[:class] = classnames(
        theme.apply(:item, self),
        theme.apply("item/button", self),
        options[:class]
      )

      FoxTail::WrapperComponent.new options do |wrapper|
        render FoxTail::LinkComponent.new url, wrapper.html_attributes do |link|
          capture link, &block
        end
      end
    },
    text: lambda { |text_or_options = {}, options = {}, &block|
      if text_or_options.is_a?(Hash)
        options = text_or_options
        text_or_options = nil
      end

      options[:class] = classnames(
        theme.apply(:item, self),
        theme.apply("item/text", self),
        options[:class]
      )

      FoxTail::WrapperComponent.new options do |wrapper|
        content_tag :div, wrapper.html_attributes do
          text_or_options || capture(&block)
        end
      end
    },
    button: lambda { |options = {}, &block|
      options[:size] ||= :sm
      options[:variant] ||= :outline
      options[:color] ||= :neutral

      options[:class] = classnames(
        theme.apply(:item, self),
        theme.apply("item/button", self),
        options[:class]
      )

      FoxTail::WrapperComponent.new options do |wrapper|
        render FoxTail::ButtonComponent.new wrapper.html_attributes do |button|
          capture button, &block
        end
      end
    }
  }

  has_option :variant, default: :default

  def render?
    items?
  end

  def before_render
    super

    with_separator_icon :chevron_right unless separator?

    html_attributes[:aria] ||= {}
    html_attributes[:aria][:label] = t("components.fox_tail.breadcrumb.label", default: "Breadcrumbs")
  end

  def call
    content_tag :nav, html_attributes do
      concat render_list
      concat content if content?
    end
  end

  private

  def render_list
    content_tag :ol, class: theme.apply("container", self) do
      items.each_with_index do |item, index|
        concat separator if index.positive?
        concat render_item(item, index)
      end
    end
  end

  def render_item(item, index)
    attributes = {}

    if index == items.length - 1
      attributes[:aria] = { current: :page }
      item.with_html_class theme.apply("item/current", self)
    end

    content_tag :li, item, attributes
  end
end
