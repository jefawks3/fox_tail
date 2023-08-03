# frozen_string_literal: true

module Flowbite::Concerns::HasStimulusController
  extend ActiveSupport::Concern

  included do
    delegate :stimulus_controller, :stimulus_controller_identifier, :use_stimulus?, :stimulus_merger, to: :class
  end

  class_methods do
    def stimulus_controller
      @stimulus_controller ||= Flowbite::ViewComponents::StimulusController.new stimulus_controller_identifier
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

    def stimulus_merger
      Flowbite::ViewComponents::Base.flowbite_config.stimulus_merger
    end
  end
end
