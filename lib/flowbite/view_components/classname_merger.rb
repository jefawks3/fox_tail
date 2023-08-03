# frozen_string_literal: true

require 'tailwind_merge'

module Flowbite
  module ViewComponents
    # Tailwind CSS class name merger
    class ClassnameMerger
      def initialize
        @base_merger = TailwindMerge::Merger.new
      end

      # Merge Tailwind class names removing any styling conflicts
      def merge(classes)
        normalized = Array(classes).flatten.each_with_object([]) do |value, results|
          next results unless value.is_a? String

          str = value.strip
          next results if str.empty?

          results << str
        end

        return nil if normalized.empty?

        @base_merger.merge normalized.join(" ")
      end
    end
  end
end
