# frozen_string_literal: true

module Flowbite
  module ViewComponents

    # Flowbite Component Theme
    class Theme
      BASE_KEY = "base"

      def initialize(theme = {}, class_merger: ClassnameMerger.new)
        @class_merger = class_merger
        @base_theme = (theme || {}).deep_stringify_keys
      end

      # Merge another theme into the current theme
      def merge!(theme)
        theme = Theme.load_file theme if theme.is_a? String
        theme = theme.base_theme if theme.is_a? Theme
        base_theme.deep_merge! theme
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
        key = normalize_key key
        return if key.blank?

        lookup_key base_theme, key
      end

      alias [] classname

      def theme(key)
        key = normalize_key key
        return if key.blank?

        hash = lookup_key base_theme, key
        return if hash.blank?

        self.class.new hash
      end

      def apply(key, object, attributes = {})
        key = normalize_key key
        return if key.blank? || object.blank?

        object_theme = lookup_key base_theme, key
        attributes = ActiveSupport::HashWithIndifferentAccess.new attributes
        object = ActiveSupport::HashWithIndifferentAccess.new object if object.is_a? Hash
        apply_theme object_theme, object, attributes
      end

      def to_h
        @base_theme.deep_dup.to_h
      end

      delegate :to_json, :as_json, to: :to_h

      protected

      attr_reader :base_theme, :class_merger

      def normalize_key(key)
        Array(key).map { |k| k.to_s.split "." }.flatten.presence
      end

      def lookup_key(theme, key)
        return theme if key.empty?
        return nil unless theme.is_a? Hash

        lookup_key theme[key.shift], key
      end

      def apply_theme(theme, object, attributes)
        return if theme.blank?

        theme.inject(theme[BASE_KEY]) do |classes, (key, value)|
          class_merger.merge [classes, apply_classes_for(object, attributes, key, value)]
        end
      end

      def apply_classes_for(object, attributes, key, value)
        object_value = object_attribute_value object, attributes, key.to_sym

        if value.is_a? Hash
          theme = value[object_value&.to_s]
          theme.is_a?(Hash) ? apply_theme(theme, object, attributes) : theme
        elsif object_value
          value
        end
      end

      def object_attribute_value(object, attributes, attribute)
        if attributes.key?(attribute)
          attributes[attribute]
        elsif object.is_a?(Hash)
          object[attribute]
        elsif object.respond_to? attribute, true
          object.send attribute
        end
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
