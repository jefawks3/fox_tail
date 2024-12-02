# frozen_string_literal: true

class FoxTail::PopoverComponent < FoxTail::BaseComponent
  ACTIONS = {
    hover: {
      hoverShow: :mouseenter,
      hoverHide: :mouseleave
    }
  }.freeze

  include FoxTail::Concerns::Identifiable

  renders_one :header, lambda { |text_or_attributes = {}, attributes = {}, &block|
    attributes = text_or_attributes if block
    attributes[:class] = classnames theme.classname("header.base"), attributes[:class]
    content_tag :h3, attributes, &block
  }

  renders_one :trigger, lambda { |attributes = {}|
    attributes[:trigger_type] = trigger_type
    attributes[:delay] = delay
    attributes[:id] = trigger_id
    FoxTail::PopoverTriggerComponent.new "##{id}", attributes
  }

  has_option :variant, default: :default
  has_option :placement, default: :top
  has_option :arrow, default: true, type: :boolean
  has_option :offset, default: 8
  has_option :shift
  has_option :inline, default: false, type: :boolean
  has_option :delay, default: 300
  has_option :trigger_id
  has_option :trigger_type, default: :hover

  stimulated_with [:fox_tail, :popover], as: :popover do |controller|
    controller.with_value :placement, placement
    controller.with_value :offset, offset
    controller.with_value :shift, shift
    controller.with_value :inline, inline?
    controller.with_value :delay, delay
    controller.with_class :visible, theme.apply("root/visible", self)
    controller.with_class :hidden, theme.apply("root/hidden", self)
    controller.with_outlet trigger_controller.identifier, "##{trigger_id}"

    ACTIONS[trigger_type]&.each do |method, event|
      controller.with_action method, on: event
    end
  end

  def initialize(id_or_attributes = {}, html_attributes = {})
    if id_or_attributes.is_a? Hash
      html_attributes = id_or_attributes
    else
      __id_argument_deprecated_warning
      html_attributes[:id] = id_or_attributes
    end

    super(html_attributes)
  end

  def trigger_controller
    stimulated.with [:fox_tail, :popover_trigger]
  end

  def trigger_id
    options[:trigger_id] ||= :"#{id}_trigger"
  end

  def before_render
    super

    generate_unique_id
    html_attributes[:role] ||= :tooltip
    html_attributes[:class] = classnames theme.apply(:root, self), theme.apply("root/hidden", self), html_class
  end

  def call
    capture do
      concat trigger if trigger?
      concat render_popover
    end
  end

  private

  def render_popover
    content_tag :div, html_attributes do
      concat header if header?
      concat content_tag(:div, content, class: theme.apply(:content, self))
      concat render_arrow if arrow?
    end
  end

  def render_arrow
    content_tag :div, nil, class: theme.apply(:arrow, self)
  end
end
