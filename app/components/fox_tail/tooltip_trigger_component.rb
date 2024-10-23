# frozen_string_literal: true

class FoxTail::TooltipTriggerComponent < FoxTail::TriggerBaseComponent
  def trigger_type
    options[:trigger_type] ||= :hover
  end

  class StimulusController < FoxTail::StimulusController
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
      FoxTail::TooltipComponent.stimulus_controller_identifier
    end

    def attributes(options = nil)
      trigger_type = options[:trigger_type]&.to_sym
      attributes = super
      attributes[:data][outlet_key(tooltip_identifier)] = options[:selector]
      attributes[:data][:action] = build_actions TRIGGER_TYPES[trigger_type]
      attributes
    end
  end
end
