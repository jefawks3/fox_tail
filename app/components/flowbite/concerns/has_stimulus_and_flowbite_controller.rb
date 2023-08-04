# frozen_string_literal: true

module Flowbite::Concerns::HasStimulusAndFlowbiteController
  extend ActiveSupport::Concern

  include Flowbite::Concerns::HasStimulusController
  include Flowbite::Concerns::HasFlowbiteController

  included do
    delegate :controller, to: :class
  end

  def controller_options
    raise NotImplementedError
  end

  def stimulus_controller_options
    controller_options
  end

  def flowbite_controller_options
    controller_options
  end

  class_methods do
    def controller
      use_stimulus? ? stimulus_controller : flowbite_controller
    end
  end
end
