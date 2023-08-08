# frozen_string_literal: true

class Flowbite::TooltipComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController
  include Flowbite::Concerns::HasStimulusTriggerController

  attr_reader :id

  renders_one :trigger, lambda { |attributes = {}, &block|
    tag_name = attributes.delete(:tag) || :span
    attributes[:id] = trigger_id
    options = attributes.extract! :trigger_type

    if use_stimulus?
      options[:tooltip_id] = "##{id}"
      options[:trigger_type] ||= :hover
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
  has_option :trigger_id

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
                                         theme.classname([:root, :color, variant]),
                                         theme.classname("root.hidden"),
                                         html_class

    stimulus_controller.merge! html_attributes, stimulus_controller_options if use_stimulus?
  end

  def call
    tooltip_content = content_tag :div, html_attributes do
      concat content
      concat render_arrow if arrow?
    end

    if trigger?
      capture do
        concat trigger
        concat tooltip_content
      end
    else
      tooltip_content
    end
  end

  def stimulus_controller_options
    {
      trigger_id: "##{trigger_id}",
      placement: placement,
      offset: offset,
      shift: shift,
      inline: inline?,
      visible_classes: theme.classname("root.visible"),
      hidden_classes: theme.classname("root.hidden")
    }
  end

  private

  def render_arrow
    classes = classnames theme.classname("arrow.base"), theme.classname([:arrow, :color, variant])
    content_tag(:div, nil, class: classes)
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    def attributes(options = {})
      {
        data: {
          controller: identifier,
          value_key(:placement) => options[:placement],
          value_key(:offset) => options[:offset],
          value_key(:shift) => options[:shift],
          value_key(:inline) => options[:inline],
          classes_key(:visible) => options[:visible_classes],
          classes_key(:hidden) => options[:hidden_classes],
          outlet_key(Flowbite::TooltipComponent.stimulus_trigger_identifier) => options[:trigger_id]
        }
      }
    end
  end

  class StimulusTriggerController < Flowbite::ViewComponents::StimulusController
    TRIGGER_TYPES = {
      hover: {
        show: %i[mouseenter focus],
        hide: %i[mouseleave blur]
      },
      click: {
        show: %i[click focus],
        hide: %i[focusout blur]
      }
    }.freeze

    def attributes(options = nil)
      trigger_type = options[:trigger_type]&.to_sym

      {
        data: {
          controller: identifier,
          outlet_key(Flowbite::TooltipComponent.stimulus_controller_identifier) => options[:tooltip_id],
          action: (build_actions(TRIGGER_TYPES[trigger_type]) if TRIGGER_TYPES.key? trigger_type)
        }
      }
    end
  end
end
