# frozen_string_literal: true

require 'view_component'

module FoxTail
  class Base < ::ViewComponent::Base
    class << self
      def fox_tail_config
        Config.current
      end
    end

    ActiveSupport.run_load_hooks :fox_tail, self
  end
end
