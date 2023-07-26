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
            classname_merger: Flowbite::ViewComponents::Merger.new,
            cache_theme: false
          })
        end
      end
    end
  end
end
