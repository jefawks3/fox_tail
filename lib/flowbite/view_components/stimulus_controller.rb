# frozen_string_literal: true

module Flowbite
  module ViewComponents
    class StimulusController < Controller
      delegate :stimulus_merger, to: :config

      def target_key(raw: false)
        key :target, raw: raw
      end

      def outlet_key(raw: false)
        key :outlet, raw: raw
      end

      def value_key(name, raw: false)
        key name, :value, raw: raw
      end

      def classes_key(name, raw: false)
        key name, :class, raw: raw
      end

      def merge!(attributes, options = {})
        stimulus_merger.merge_attributes! attributes, self.attributes(options)
      end

      protected

      def key(*parts)
        super identifier, *parts
      end
    end
  end
end
