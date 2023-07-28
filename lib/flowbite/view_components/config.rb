# frozen_string_literal: true

require 'flowbite/view_components/merger'

module Flowbite
  module ViewComponents
    class Config
      def initialize
        @config = self.class.defaults
      end

      delegate_missing_to :@config

      class << self
        alias_method :default, :new

        def defaults
          ActiveSupport::OrderedOptions.new.merge!({
            classname_merger: Merger.new,
            stimulus_controller_prefix: "flowbite-",
            use_stimulus: true
          })
        end
      end
    end
  end
end
