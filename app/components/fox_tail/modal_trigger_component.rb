# frozen_string_literal: true

class FoxTail::ModalTriggerComponent < FoxTail::TriggerBaseComponent
  class StimulusController < FoxTail::StimulusController
    def modal_identifier
      FoxTail::ModalComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      attributes = super options
      attributes[:data][outlet_key(self.modal_identifier)] = options[:selector]
      attributes[:data][:action] = action options.fetch(:action, :show), event: options.fetch(:trigger_type, :click)
      attributes
    end
  end
end
