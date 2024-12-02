# frozen_string_literal: true

class FoxTail::Dropdown::MenuItemComponent < FoxTail::ClickableComponent
  renders_one :left_visual, types: {
    icon: {
      renders: lambda { |icon, options = {}| render_icon icon, options, :start },
      as: :left_icon
    },
    svg: {
      renders: lambda { |path, options = {}| render_svg path, options, :start },
      as: :left_svg
    },
    image: {
      renders: lambda { |url, attributes = {}| render_image url, attributes, :start },
      as: :left_image
    }
  }

  renders_one :right_visual, types: {
    icon: {
      renders: lambda { |icon, options = {}| render_icon icon, options, :end },
      as: :right_icon
    },
    svg: {
      renders: lambda { |path, options = {}| render_svg path, options, :end },
      as: :right_svg
    },
    image: {
      renders: lambda { |url, attributes = {}| render_image url, attributes, :end },
      as: :right_image
    }
  }

  has_option :color, default: :default
  has_option :autocomplete_value
  has_option :autocomplete_text

  stimulated_with [:fox_tail, :autocomplete], as: :autocomplete, register: false

  def visuals?
    left_visual? || right_visual?
  end

  def before_render
    super

    if options.key?(:autocomplete_value)
      autocomplete_controller.with_param :value, autocomplete_value
      autocomplete_controller.with_param :text, autocomplete_text
      autocomplete_controller.with_action :select
    end
  end

  def call
    super do
      concat left_visual if left_visual?
      concat content
      concat right_visual if right_visual?
    end
  end

  private

  def render_icon(icon, options, side)
    options[:"aria-hidden"] = true
    options[:class] = classnames theme.apply(:visual, self, side: side), options[:class]
    FoxTail::IconBaseComponent.new icon, options
  end

  def render_svg(path, options, side)
    options[:"aria-hidden"] = true
    options[:class] = classnames theme.apply(:visual, self, side: side), options[:class]
    FoxTail::InlineSvgComponent.new path, options
  end

  def render_image(uri, options, side)
    options[:"aria-hidden"] = true
    options[:class] = classnames theme.apply(:visual, self, side: side), options[:class]
    image_tag uri, options
  end
end
