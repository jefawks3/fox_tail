# frozen_string_literal: true

class Flowbite::DropdownComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController

  attr_reader :id

  renders_one :trigger, lambda { |options = {}, &block|
    options[:trigger_type] = trigger_type
    options[:delay] = delay
    Flowbite::DropdownTriggerComponent.new trigger_id, "##{id}", options, &block
  }

  renders_one :header, lambda { |options = {}, &block|
    attributes = options.merge class: classnames(theme.apply(:header, self), options[:class])
    content_tag :div, attributes, &block
  }

  renders_many :menus, Flowbite::Dropdown::MenuComponent

  has_option :divider, default: true, type: :boolean
  has_option :placement, default: "bottom"
  has_option :offset, default: 10
  has_option :shift
  has_option :ignore_click_outside
  has_option :trigger_id
  has_option :trigger_type, default: :click
  has_option :delay, default: 300

  def initialize(id, html_attributes = {})
    super(html_attributes)
    @id = id
  end

  def trigger_id
    options[:trigger_id] ||= :"#{id}_trigger"
  end

  def before_render
    super

    html_attributes[:id] = id
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
      menus.each { |menu| concat menu } if menus?
      concat content if content?
    end
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    TRIGGER_TYPES = {
      hover: {
        hoverShow: :mouseenter,
        hoverHide: :mouseleave
      }
    }.freeze

    def trigger_identifier
      Flowbite::DropdownTriggerComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      trigger_type = options[:trigger_type]&.to_sym
      attributes = super options
      attributes[:data][value_key(:placement)] = options[:placement]
      attributes[:data][value_key(:offset)] = options[:offset]
      attributes[:data][value_key(:shift)] = options[:shift]
      attributes[:data][value_key(:ignore_click_outside)] = options[:ignore_click_outside]
      attributes[:data][outlet_key(trigger_identifier)] = "##{options[:trigger_id]}"
      attributes[:data][classes_key(:hidden)] = options[:hidden_classes]
      attributes[:data][classes_key(:visible)] = options[:visible_classes]
      attributes[:data][:action] = build_actions TRIGGER_TYPES[trigger_type]
      attributes
    end
  end
end
