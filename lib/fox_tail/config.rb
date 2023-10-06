# frozen_string_literal: true

require 'fox_tail/classname_merger'
require 'fox_tail/stimulus_merger'

module FoxTail
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
                                                   raise_on_asset_not_found: true,
                                                   color_theme: ActiveSupport::OrderedOptions.new
                                                 })
      end
    end
  end
end
