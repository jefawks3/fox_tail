# frozen_string_literal: true

class FoxTail::DropdownComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable
  include FoxTail::Concerns::HasStimulusController

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

  def before_render
    super

    generate_unique_id
    html_attributes[:class] = classnames theme.apply(:root, self),
                                         theme.apply("root/hidden", self),
                                         html_class
  end

  def call
    capture do
      concat trigger if trigger?
      concat render_dropdown
    end
  end

  def stimulus_controller_options
    {
      trigger_id: trigger_id,
      placement: placement,
      offset: offset,
      shift: shift,
      ignore_click_outside: ignore_click_outside,
      disable_click_outside: disable_click_outside?,
      hidden_classes: theme.apply("root/hidden", self),
      visible_classes: theme.apply("root/visible", self),
      trigger_type: trigger_type,
      delay: delay
    }
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

  class StimulusController < FoxTail::StimulusController
    TRIGGER_TYPES = {
      hover: {
        hoverShow: :mouseenter,
        hoverHide: :mouseleave
      }
    }.freeze

    def trigger_identifier
      FoxTail::DropdownTriggerComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      trigger_type = options[:trigger_type]&.to_sym
      attributes = super options
      attributes[:data][value_key(:placement)] = options[:placement]
      attributes[:data][value_key(:offset)] = options[:offset]
      attributes[:data][value_key(:shift)] = options[:shift]
      attributes[:data][value_key(:ignore_click_outside)] = options[:ignore_click_outside]
      attributes[:data][value_key(:disable_click_outside)] = options[:disable_click_outside]
      attributes[:data][outlet_key(trigger_identifier)] = "##{options[:trigger_id]}"
      attributes[:data][classes_key(:hidden)] = options[:hidden_classes]
      attributes[:data][classes_key(:visible)] = options[:visible_classes]
      attributes[:data][:action] = build_actions TRIGGER_TYPES[trigger_type]
      attributes
    end
  end
end
