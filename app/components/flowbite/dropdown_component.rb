# frozen_string_literal: true

class Flowbite::DropdownComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController
  include Flowbite::Concerns::HasStimulusTriggerController

  attr_reader :id, :trigger_id

  renders_one :trigger, types: {
    button: {
      renders: lambda { |icon: :chevron_down, **options|
        merge_trigger_attributes! options
        button = Flowbite::ButtonComponent.new(options)
        button.with_right_icon icon if icon.present?
        button
      },
      as: :button_trigger
    },
    icon: {
      renders: lambda { |icon, options = {}|
        merge_trigger_attributes! options
        Flowbite::IconButtonComponent.new icon, options
      },
      as: :icon_button_trigger
    },
    component: {
      renders: lambda { |tag_name: :button, **options, &block|
        merge_trigger_attributes! options
        content_tag tag_name, options, &block
      },
      as: :trigger
    }
  }

  renders_one :header, lambda { |options = {}, &block|
    content_tag :div, options.merge(class: classnames(theme.classname("header.base"), options[:class])), &block
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
    @id = id
    super(html_attributes)
  end

  def trigger_id
    options[:trigger_id] ||= :"#{html_attributes.delete(:trigger_id) || id}_trigger"
  end

  def before_render
    super

    stimulus_controller.merge! html_attributes, stimulus_controller_options if use_stimulus?
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
      hidden_classes: theme.classname("root.hidden"),
      visible_classes: theme.classname("root.visible"),
      trigger_type: trigger_type,
      delay: delay
    }
  end

  private

  def render_dropdown
    root_classes = classnames theme.classname("root.base"),
                              theme.classname("root.hidden"),
                              divider? && theme.classname("root.divider"),
                              html_class

    content_tag :div, html_attributes.merge(id: id, class: root_classes) do
      concat header if header?
      menus.each { |menu| concat menu } if menus?
      concat content if content?
    end
  end

  def merge_trigger_attributes!(attributes)
    options = attributes.extract! :delay, :trigger_type

    attributes[:id] = trigger_id

    return attributes unless use_stimulus?

    options[:dropdown_id] = id
    options[:trigger_type] = trigger_type
    options[:delay] = delay
    stimulus_trigger.merge! attributes, options
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
          value_key(:ignore_click_outside) => options[:ignore_click_outside],
          outlet_key(Flowbite::DropdownComponent.stimulus_trigger_identifier) => "##{options[:trigger_id]}",
          classes_key(:hidden) => options[:hidden_classes],
          classes_key(:visible) => options[:visible_classes],
          action: (build_actions(TRIGGER_TYPES[trigger_type]) if TRIGGER_TYPES.key? trigger_type)
        }
      }
    end
  end

  class StimulusTriggerController < Flowbite::ViewComponents::StimulusController
    TRIGGER_TYPES = {
      hover: {
        show: :click,
        hoverShow: :mouseenter,
        hoverHide: :mouseleave
      },
      click: {
        toggle: :click
      }
    }.freeze

    def attributes(options = {})
      trigger_type = options[:trigger_type]&.to_sym

      {
        data: {
          controller: identifier,
          value_key(:delay) => options[:delay],
          outlet_key(Flowbite::DropdownComponent.stimulus_controller_identifier) => "##{options[:dropdown_id]}",
          action: (build_actions(TRIGGER_TYPES[trigger_type]) if TRIGGER_TYPES.key? trigger_type)
        }
      }
    end
  end
end
