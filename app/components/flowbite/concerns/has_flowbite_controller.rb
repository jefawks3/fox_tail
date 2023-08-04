# frozen_string_literal: true

module Flowbite::Concerns::HasFlowbiteController
  extend ActiveSupport::Concern

  included do
    delegate :flowbite_controller, :flowbite_controller_identifier, to: :class
  end

  def flowbite_controller_options
    raise NotImplementedError
  end

  class_methods do
    def flowbite_controller
      @flowbite_controller ||= find_flowbite_controller!
    end

    def flowbite_controller_identifier
      name.demodulize.underscore.gsub(/_component$/, "").to_sym
    end

    def use_flowbite?
      !Flowbite::ViewComponents::Base.flowbite_config.use_stimulus
    end

    private

    def find_flowbite_controller!
      find_flowbite_controller(self) ||
        raise(Flowbite::ViewComponents::ControllerNotImplemented, "Stimulus controller for #{name} not defined.")
    end

    def find_flowbite_controller(klass)
      if defined? klass::FlowbiteController
        klass::FlowbiteController.new flowbite_controller_identifier
      elsif superclass != Flowbite::ViewComponents::Base
        find_flowbite_controller klass.superclass
      end
    end
  end
end
