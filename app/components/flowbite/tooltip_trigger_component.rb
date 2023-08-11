# frozen_string_literal: true

class Flowbite::TooltipTriggerComponent < Flowbite::TriggerBaseComponent
  def initialize(id, selector, html_attributes = {})
    super
    with_trigger_type :hover unless trigger_type?
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    TRIGGER_TYPES = {
      hover: {
        show: %i[mouseenter focus],
        hide: %i[mouseleave blur]
      },
      click: {
        toggle: :click,
        hide: %i[focusout blur]
      }
    }.freeze

    def tooltip_identifier
      Flowbite::TooltipComponent.stimulus_controller_identifier
    end

    def attributes(options = nil)
      trigger_type = options[:trigger_type]&.to_sym
      attributes = super options
      attributes[:data][outlet_key(tooltip_identifier)] = options[:selector]
      attributes[:data][:action] = build_actions TRIGGER_TYPES[trigger_type]
      attributes
    end
  end
end
