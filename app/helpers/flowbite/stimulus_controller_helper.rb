# frozen_string_literal: true

module Flowbite::StimulusControllerHelper
  extend ActiveSupport::Concern

  included do
    delegate :stimulus_controller, :stimulus_controller_identifier, :use_stimulus?, to: :class
  end

  class_methods do
    def stimulus_controller
      @stimulus_controller ||= Flowbite::ViewComponents::StimulusController.new stimulus_controller_identifier
    end

    def stimulus_controller_identifier
      [
        flowbite_config.stimulus_controller_prefix,
        stimulus_controller_name.to_s
      ].reject(&:blank?).join("-").gsub("_", "-")
    end

    def stimulus_controller_name
      name.demodulize.underscore.gsub(/_component$/, "").to_sym
    end

    def use_stimulus?
      !!flowbite_config.use_stimulus
    end
  end

  protected

  def stimulus_controllers(*controllers)
    Flowbite::ViewComponents::StimulusController.merge controllers
  end
end
