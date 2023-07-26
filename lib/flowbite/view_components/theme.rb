# frozen_string_literal: true

module Flowbite
  module ViewComponents

    # Flowbite Component Theme
    class Theme
      def initialize(theme = {})
        @base_theme = (theme || {}).deep_stringify_keys
      end

      # Merge another theme into the current theme
      def merge!(theme)
        theme = Theme.load_file theme if theme.is_a? String
        theme = theme.base_theme if theme.is_a? Theme
        base_theme.merge! theme
        self
      end

      def merge(theme)
        dup.merge! theme
      end

      def dup
        Theme.new @base_theme.deep_dup
      end

      # Return the classnames for the `key` in the theme
      def classname(key)
        return nil unless key.present?

        normalized_key = Array(key).map { |k| k.to_s.split "." }.flatten
        lookup_key base_theme, normalized_key
      end

      alias [] classname

      protected

      attr_reader :base_theme

      private

      def lookup_key(theme, key)
        return theme if key.empty? && theme.is_a?(String)
        return nil unless theme.is_a? Hash

        lookup_key theme[key.shift], key
      end

      class << self
        # Load the theme from a YAML file
        # @param [String] file The path to the theme file.
        # @return [Flowbite::ViewComponents::Theme] The loaded theme object.
        # @raise [IO::Error] if unable to load the theme file
        def load_file(file)
          new YAML.load_file(file, aliases: true)
        end
      end
    end
  end
end
