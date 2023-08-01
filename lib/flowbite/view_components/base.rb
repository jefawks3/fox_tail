# frozen_string_literal: true

require 'view_component'

module Flowbite
  module ViewComponents
    class Base < ::ViewComponent::Base
      class << self
        def flowbite_config
          @flowbite_config ||= Config.defaults
        end

        attr_writer :flowbite_config
      end

      ActiveSupport.run_load_hooks :flowbite_view_component, self
    end
  end
end
