# frozen_string_literal: true

class FoxTail::DropdownComponent < FoxTail::BaseComponent
  ACTIONS = {
    hover: {
      hoverShow: :mouseenter,
      hoverHide: :mouseleave
    }.freeze
  }.freeze

  include FoxTail::Concerns::Identifiable

  renders_one :trigger, lambda { |options = {}, &block|
    options[:trigger_type] = trigger_type
    options[:delay] = delay
    options[:id] = trigger_id
    FoxTail::DropdownTriggerComponent.new "##{id}", options, &block
  }

  renders_one :header, lambda { |options = {}, &block|
    attributes = options.merge class: classnames(theme.apply(:header, self), options[:class])
    content_tag :div, attributes, &block
  }

  renders_many :menus, lambda { |options = {}|
    options[:theme] = theme.theme :menu
    FoxTail::Dropdown::MenuComponent.new options
  }

  renders_one :footer, lambda { |options = {}, &block|
    attributes = options.merge class: classnames(theme.apply(:footer, self), options[:class])
    content_tag :div, attributes, &block
  }

  has_option :divider, default: true, type: :boolean
  has_option :placement, default: "bottom"
  has_option :offset, default: 10
  has_option :shift
  has_option :ignore_click_outside
  has_option :disable_click_outside, type: :boolean, default: false
  has_option :trigger_id
  has_option :trigger_type, default: :click
  has_option :delay, default: 300
  has_option :scroll, type: :boolean, default: false

  stimulated_with [:fox_tail, :dropdown], as: :dropdown do |controller|
    controller.with_value :placement, placement
    controller.with_value :offset, offset
    controller.with_value :shift, shift
    controller.with_value :ignore_click_outside, ignore_click_outside?
    controller.with_value :disable_click_outside, disable_click_outside?
    controller.with_outlet trigger_controller.identifier, "##{trigger_id}"
    controller.with_class :hidden, theme.apply("root/hidden", self)
    controller.with_class :visible, theme.apply("root/visible", self)

    ACTIONS[trigger_type&.to_sym]&.each do |method, event|
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

  def trigger_id
    options[:trigger_id] ||= :"#{id}_trigger"
  end

  def trigger_controller
    stimulated.with([:fox_tail, :dropdown_trigger])
  end

  def before_render
    super

    generate_unique_id

    html_attributes[:class] = classnames(
      theme.apply(:root, self),
      theme.apply("root/hidden", self),
      html_class
    )
  end

  def call
    capture do
      concat trigger if trigger?
      concat render_dropdown
    end
  end

  protected

  def render_dropdown
    content_tag :div, html_attributes do
      concat header if header?
      concat render_dropdown_body
      concat footer if footer?
    end
  end

  def render_dropdown_body
    content_tag :div, class: theme.apply(:body, self) do
      menus.each { |menu| concat menu } if menus?
      concat content if content?
    end
  end
end
