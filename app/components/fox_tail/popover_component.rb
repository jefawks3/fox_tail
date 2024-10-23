# frozen_string_literal: true

class FoxTail::PopoverComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable
  include FoxTail::Concerns::HasStimulusController

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
    html_attributes[:role] ||= :tooltip
    html_attributes[:class] = classnames theme.apply(:root, self), theme.apply("root/hidden", self), html_class
    stimulus_controller.merge! html_attributes, stimulus_controller_options if use_stimulus?
  end

  def call
    capture do
      concat trigger if trigger?
      concat render_popover
    end
  end

  def stimulus_controller_options
    {
      trigger_id: trigger_id,
      placement: placement,
      offset: offset,
      shift: shift,
      inline: inline?,
      delay: delay,
      trigger_type: trigger_type,
      visible_classes: theme.apply("root/visible", self),
      hidden_classes: theme.apply("root/hidden", self)
    }
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

  class StimulusController < FoxTail::StimulusController
    TRIGGER_TYPES = {
      hover: {
        hoverShow: :mouseenter,
        hoverHide: :mouseleave
      }
    }.freeze

    def trigger_identifier
      FoxTail::PopoverTriggerComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      trigger_type = options[:trigger_type]&.to_sym
      attributes = super
      attributes[:data][value_key(:placement)] = options[:placement]
      attributes[:data][value_key(:offset)] = options[:offset]
      attributes[:data][value_key(:shift)] = options[:shift]
      attributes[:data][value_key(:inline)] = options[:inline]
      attributes[:data][value_key(:delay)] = options[:delay]
      attributes[:data][outlet_key(trigger_identifier)] = "##{options[:trigger_id]}"
      attributes[:data][classes_key(:hidden)] = options[:hidden_classes]
      attributes[:data][classes_key(:visible)] = options[:visible_classes]
      attributes[:data][:action] = build_actions TRIGGER_TYPES[trigger_type]
      attributes
    end
  end
end
