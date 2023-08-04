# frozen_string_literal: true

module Flowbite
  module ViewComponents
    class FlowbiteController < Controller
      def target_key
        key
      end

      def option_key(*parts)
        key(*parts)
      end

      protected

      def key(*parts)
        super identifier, *parts
      end
    end
  end
end
