# frozen_string_literal: true

class FoxTail::Accordion::ItemComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable

  attr_reader :title

  renders_one :icon, types: {
    icon: {
      renders: lambda { |icon, options = {}|
        options[:class] = classnames theme.classname("icon.base"), options[:class]
        options[:variant] ||= :mini
        FoxTail::IconBaseComponent.new icon, options
      },
      as: :icon
    },
    svg: {
      renders: lambda { |path, attributes = {}|
        attributes[:class] = classnames theme.classname("icon.base"), attributes[:class]
        FoxTail::InlineSvgComponent.new path, attributes
      },
      as: :svg_icon
    },
    image: {
      renders: lambda { |path, attributes = {}|
        attributes[:class] = classnames theme.classname("icon.base"), attributes[:class]
        image_tag path, attributes
      },
      as: :image_icon
    }
  }


  renders_one :arrow, types: {
    icon: {
      renders: lambda { |options = {}|
        icon_options = options.extract!(:icon, :rotate).reverse_merge(icon: :chevron_down, rotate: true)
        options[:class] = classnames theme.apply(:arrow, icon_options), options[:class]
        FoxTail::IconBaseComponent.new icon_options[:icon], options
      },
      as: :arrow
    },
    svg: {
      renders: lambda { |path, options = {}|
        svg_options = options.extract!(:rotate).reverse_merge(rotate: true)
        options[:class] = classnames theme.apply(:arrow, svg_options), options[:class]
        FoxTail::InlineSvgComponent.new path, options
      },
      as: :svg_arrow
    },
    image: {
      renders: lambda { |path, options = {}|
        img_options = options.extract!(:rotate).reverse_merge(rotate: true)
        options[:class] = classnames theme.apply(:arrow, img_options), options[:class]
        image_tag path, options
      },
      as: :image_arrow
    }
  }

  has_option :position, default: :middle
  has_option :flush, default: false, type: :boolean
  has_option :open, default: false, type: :boolean
  has_option :header_tag, default: :h2

  def initialize(id_or_title, title_or_attributes = {}, html_attributes = {})
    if title_or_attributes.is_a? Hash
      html_attributes = title_or_attributes
      title_or_attributes = id_or_title
    else
      __id_argument_deprecated_warning
      html_attributes[:id] = id_or_title
    end

    @title = title_or_attributes
    super(html_attributes)
  end

  def body_id
    :"#{id}_body"
  end

  def trigger_id
    :"#{id}_trigger"
  end

  def before_render
    super

    generate_unique_id
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, html_attributes do
      concat render_header
      concat render_body
    end
  end

  private

  def body_classes
    theme.apply :body, self
  end

  def header_classes
    theme.apply :header, self
  end

  def render_header
    content_tag header_tag, id: id do
      render(FoxTail::CollapsibleTriggerComponent.new(
        "##{body_id}",
        id: trigger_id,
        open: open?,
        class: header_classes
      )) do |trigger|
        content_tag :button, trigger.html_attributes do
          concat icon if icon?
          concat content_tag(:span, title)
          concat arrow if arrow?
        end
      end
    end
  end

  def render_body
    render(FoxTail::CollapsibleComponent.new(
      id: body_id,
      open: open?,
      data: { FoxTail::AccordionComponent.stimulus_controller.target_key => :collapsible },
      aria: { labelledby: id }
    )) do
      content_tag :div, content, class: body_classes
    end
  end
end