# frozen_string_literal: true

module Flowbite::Concerns::HasStimulusController
  extend ActiveSupport::Concern

  included do
    delegate :stimulus_controller, :stimulus_controller_identifier, :use_stimulus?, to: :class
  end

  def stimulus_controller_options
    raise NotImplementedError
  end

  class_methods do
    def stimulus_controller
      @stimulus_controller ||= find_stimulus_controller!
    end

    def stimulus_controller_identifier
      [
        Flowbite::ViewComponents::Base.flowbite_config.stimulus_controller_prefix,
        stimulus_controller_name.to_s
      ].reject(&:blank?).join("-").gsub("_", "-")
    end

    def stimulus_controller_name
      name.demodulize.underscore.gsub(/_component$/, "").to_sym
    end

    def use_stimulus?
      !!Flowbite::ViewComponents::Base.flowbite_config.use_stimulus
    end

    private

    def find_stimulus_controller!
      find_stimulus_controller(self) ||
        raise(Flowbite::ViewComponents::ControllerNotImplemented, "Stimulus controller for #{name} not defined.")
    end

    def find_stimulus_controller(klass)
      if defined? klass::StimulusController
        klass::StimulusController.new stimulus_controller_identifier
      elsif superclass != Flowbite::ViewComponents::Base
        find_stimulus_controller klass.superclass
      end
    end
  end
end
