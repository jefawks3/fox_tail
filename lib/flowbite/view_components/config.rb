# frozen_string_literal: true

require 'flowbite/view_components/classname_merger'
require 'flowbite/view_components/stimulus_merger'

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
            classname_merger: ClassnameMerger.new,
            stimulus_merger: StimulusMerger.new,
            use_stimulus: true,
            raise_on_asset_not_found: true
          })
        end
      end
    end
  end
end
