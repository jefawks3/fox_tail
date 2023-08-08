# frozen_string_literal: true

module Flowbite::Concerns::HasStimulusTriggerController
  extend ActiveSupport::Concern

  included do
    delegate :stimulus_trigger, :stimulus_trigger_identifier, to: :class
  end

  class_methods do
    def stimulus_trigger
      @stimulus_trigger ||= find_trigger_controller!
    end

    def stimulus_trigger_identifier
      :"flowbite--#{stimulus_trigger_name.to_s.gsub("_", "-")}"
    end

    def stimulus_trigger_name
      "#{stimulus_controller_name}_trigger".to_sym
    end

    private

    def find_trigger_controller!
      find_trigger_controller(self) ||
        raise(Flowbite::ViewComponents::ControllerNotImplemented, "Stimulus trigger controller for #{name} not defined.")
    end

    def find_trigger_controller(klass)
      if defined? klass::StimulusTriggerController
        klass::StimulusTriggerController.new stimulus_trigger_identifier
      elsif superclass != Flowbite::ViewComponents::Base
        find_trigger_controller klass.superclass
      end
    end
  end
end
