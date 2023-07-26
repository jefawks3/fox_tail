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
  end
end