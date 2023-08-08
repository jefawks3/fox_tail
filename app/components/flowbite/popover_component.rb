# frozen_string_literal: true

class Flowbite::PopoverComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController
  include Flowbite::Concerns::HasStimulusTriggerController

  attr_reader :id

  renders_one :header, lambda { |text_or_attributes = {}, attributes = {}, &block|
    attributes = text_or_attributes if block
    attributes[:class] = classnames theme.classname("header.base"), attributes[:class]
    content_tag :h3, attributes, &block
  }

  renders_one :trigger, lambda { |attributes = {}, &block|
    tag_name = attributes.delete(:tag) || :span
    attributes[:id] = trigger_id
    options = attributes.extract! :trigger_type

    if use_stimulus?
      options[:popover_id] = "##{id}"
      options[:trigger_type] = trigger_type
      options[:delay] = delay
      stimulus_trigger.merge! attributes, options
    end

    content_tag tag_name, attributes, &block
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

  def initialize(id, html_attributes = {})
    @id = id
    super(html_attributes)
  end

  def trigger_id
    options[:trigger_id] ||= :"#{html_attributes.delete(:trigger_id) || id}_trigger"
  end

  def before_render
    super

    html_attributes[:id] = id
    html_attributes[:role] ||= :tooltip
    html_attributes[:class] = classnames theme.classname("root.base"),
                                         arrow? && theme.classname("root.arrow"),
                                         theme.classname("root.hidden"),
                                         html_class

    stimulus_controller.merge! html_attributes, stimulus_controller_options if use_stimulus?
  end

  def call
    if trigger?
      capture do
        concat trigger
        concat render_popover
      end
    else
      render_popover
    end
  end

  def stimulus_controller_options
    {
      trigger_id: "##{trigger_id}",
      placement: placement,
      offset: offset,
      shift: shift,
      inline: inline?,
      delay: delay,
      trigger_type: trigger_type,
      visible_classes: theme.classname("root.visible"),
      hidden_classes: theme.classname("root.hidden")
    }
  end

  private

  def render_popover
    content_tag :div, html_attributes do
      concat header if header?
      concat content_tag(:div, content, class: theme.classname("content.base"))
      concat render_arrow if arrow?
    end
  end

  def render_arrow
    classes = classnames theme.classname("arrow.base"), header? && theme.classname("arrow.header")
    content_tag :div, nil, class: classes
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    TRIGGER_TYPES = {
      hover: {
        hoverShow: :mouseenter,
        hoverHide: :mouseleave
      }
    }.freeze

    def attributes(options = {})
      trigger_type = options[:trigger_type]&.to_sym

      {
        data: {
          controller: identifier,
          value_key(:placement) => options[:placement],
          value_key(:offset) => options[:offset],
          value_key(:shift) => options[:shift],
          value_key(:inline) => options[:inline],
          value_key(:delay) => options[:delay],
          classes_key(:visible) => options[:visible_classes],
          classes_key(:hidden) => options[:hidden_classes],
          outlet_key(Flowbite::PopoverComponent.stimulus_trigger_identifier) => options[:trigger_id],
          action: (build_actions(TRIGGER_TYPES[trigger_type]) if TRIGGER_TYPES.key? trigger_type)
        }
      }
    end
  end

  class StimulusTriggerController < Flowbite::ViewComponents::StimulusController
    TRIGGER_TYPES = {
      hover: {
        hoverShow: %i[mouseenter focus],
        hoverHide: %i[mouseleave blur],
      },
      click: {
        toggle: :click,
        hide: %i[focusout blur]
      }
    }.freeze

    def attributes(options = nil)
      trigger_type = options[:trigger_type]&.to_sym

      {
        data: {
          controller: identifier,
          value_key(:delay) => options[:delay],
          outlet_key(Flowbite::PopoverComponent.stimulus_controller_identifier) => options[:popover_id],
          action: (build_actions(TRIGGER_TYPES[trigger_type]) if TRIGGER_TYPES.key? trigger_type)
        }
      }
    end
  end
end
