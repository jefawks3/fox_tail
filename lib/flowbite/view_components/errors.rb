# frozen_string_literal: true

module Flowbite
  module ViewComponents
    class Error < StandardError; end

    class AssetNotFound < Error
      attr_reader :asset

      def initialize(asset, msg = "Could not find the asset \"#{asset}\"")
        super(msg)
        @asset = asset
      end
    end

    class ControllerNotImplemented < Error; end

    class ComponentError < Error
      attr_reader :component

      def initialize(component, msg = nil)
        @component = component
        super(msg)
      end
    end

    class ReservedOption < ComponentError
      attr_reader :option

      def initialize(component, option, msg = nil)
        @option = option
        msg ||= "#{component} declares an option \"#{option}\", which is a reserved word in the" \
          " Flowbite::ViewComponents framework."

        super(component, msg)
      end
    end
  end
end