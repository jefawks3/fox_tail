# frozen_string_literal: true

class Flowbite::PopoverTriggerComponent < Flowbite::TriggerBaseComponent
  has_option :delay, default: 300

  def initialize(id, selector, html_attributes = {})
    super
    with_trigger_type :hover unless trigger_type?
  end


  def stimulus_controller_options
    super.merge delay: delay
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    TRIGGER_TYPES = {
      hover: {
        hoverShow: %i[mouseenter focus],
        hoverHide: %i[mouseleave blur]
      },
      click: {
        toggle: :click,
        hide: %i[focusout blur]
      }
    }.freeze

    def popover_identifier
      Flowbite::PopoverComponent.stimulus_controller_identifier
    end

    def attributes(options = nil)
      trigger_type = options[:trigger_type]&.to_sym
      attributes = super options
      attributes[:data][value_key(:delay)] = options[:delay]
      attributes[:data][outlet_key(popover_identifier)] = options[:selector]
      attributes[:data][:action] = build_actions TRIGGER_TYPES[trigger_type]
      attributes
    end
  end
end
