# frozen_string_literal: true

class Flowbite::ModalTriggerComponent < Flowbite::TriggerBaseComponent
  class StimulusController < Flowbite::ViewComponents::StimulusController
    def modal_identifier
      Flowbite::ModalComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      attributes = super options
      attributes[:data][outlet_key(self.modal_identifier)] = options[:selector]
      attributes[:data][:action] = action options.fetch(:action, :show), event: options.fetch(:trigger_type, :click)
      attributes
    end
  end
end
