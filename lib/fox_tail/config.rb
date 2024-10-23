# frozen_string_literal: true

require "fox_tail/classname_merger"
require "fox_tail/stimulus_merger"

module FoxTail
  class Config
    class << self
      alias_method :default, :new

      def defaults
        ActiveSupport::OrderedOptions.new.merge!({
          classname_merger: ClassnameMerger.new,
          stimulus_merger: StimulusMerger.new,
          use_stimulus: true,
          raise_on_asset_not_found: true,
          color_theme: {},
          icon_sets: {},
          default_icon_set: nil,
          default_icon_variant: :solid
        })
      end

      def current
        @current ||= default
      end
    end

    delegate_missing_to :@config

    def initialize
      @config = self.class.defaults.clone
    end
  end
end
