# frozen_string_literal: true

class FoxTail::DropdownTriggerComponent < FoxTail::TriggerBaseComponent
  has_option :delay, default: 300
  has_option :open, default: false, type: :boolean

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self),
      theme.apply("root/#{open? ? :open : :close}", self),
      html_class
  end

  def stimulus_controller_options
    super.merge delay: delay,
      open_classes: theme.apply("root/open", self),
      closed_classes: theme.apply("root/closed", self)
  end

  class StimulusController < FoxTail::StimulusController
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

    def dropdown_identifier
      FoxTail::DropdownComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      trigger_type = options[:trigger_type]&.to_sym
      attributes = super
      attributes[:data][value_key(:delay)] = options[:delay]
      attributes[:data][outlet_key(dropdown_identifier)] = options[:selector]
      attributes[:data][classes_key(:open)] = options[:open_classes]
      attributes[:data][classes_key(:closed)] = options[:closed_classes]
      attributes[:data][:action] = build_actions(TRIGGER_TYPES[trigger_type])
      attributes
    end
  end
end
