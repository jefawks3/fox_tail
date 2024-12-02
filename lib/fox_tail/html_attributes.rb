# frozen_string_literal: true

module FoxTail
  class HtmlAttributes < ActiveSupport::HashWithIndifferentAccess
    BOOLEAN_ATTRIBUTES = %w[
      allowfullscreen allowpaymentrequest async autofocus autoplay checked compact controls declare default
      defaultchecked defaultmuted defaultselected defer disabled enabled formnovalidate hidden indeterminate
      inert ismap itemscope loop multiple muted nohref nomodule noresize noshade novalidate nowrap open
      pauseonexit playsinline readonly required reversed scoped seamless selected sortable truespeed
      typemustmatch visible
    ].freeze

    def merge_classes(*classnames)
      deep_dup.merge_classes!(*classnames)
    end

    def merge_classes!(*classnames)
      self["class"] = config.classname_merger.merge(self["class"], *classnames)
      self
    end

    def merge_stimulus_controllers(*controllers)
      deep_dup.merge_stimulus_controllers!(*controllers)
    end

    def merge_stimulus_controllers!(*controllers)
      self["data"] ||= {}
      self["data"]["controller"] = config.stimulus_merger.merge_controllers(dig("data", "controller"), *controllers)
      self
    end

    def merge_stimulus_actions(*actions)
      deep_dup.merge_stimulus_actions!(*actions)
    end

    def merge_stimulus_actions!(*actions)
      self["data"] ||= {}
      self["data"]["action"] = config.stimulus_merger.merge_actions(dig("data", "action"), *actions)
      self
    end

    def merge_stimulus(*stimulus_hash, &block)
      deep_dup.merge_stimulus!(*stimulus_hash, &block)
    end

    def merge_stimulus!(*stimulus_hash, &block)
      self["data"] = config.stimulus_merger.merge(self["data"], *stimulus_hash, &block)
      self
    end

    def to_attributes
      each_with_object({}) do |(key, value), hash|
        if key == "data" && value.is_a?(Hash)
          data_attribute(hash, value)
        elsif key == "aria" && value.is_a?(Hash)
          aria_attribute(hash, value)
        elsif BOOLEAN_ATTRIBUTES.include?(key)
          hash[key] = key if value
        else
          hash[key] = format_attribute_value(value)
        end
      end
    end

    private

    def config
      @config ||= FoxTail::Config.current.deep_dup
    end

    def data_attribute(attributes, data)
      data.each_pair do |key, value|
        next if value.nil?

        attributes[prefixed_attribute(:data, key)] = format_attribute_value(value)
      end
    end

    def aria_attribute(attributes, aria)
      aria.each_pair do |key, value|
        next if value.nil?

        if value.is_a?(Hash) || value.is_a?(Array)
          values = flatten_attribute_values(value)
          next if values.empty?

          value = values.join(" ")
        end

        attributes[prefixed_attribute(:aria, key)] = format_attribute_value(value)
      end
    end

    def prefixed_attribute(prefix, key)
      "#{prefix}-#{key.to_s.dasherize}"
    end

    def format_attribute_value(value)
      (value.is_a?(String) || value.is_a?(Symbol) || value.is_a?(BigDecimal)) ? value.to_s : value.to_json
    end

    def flatten_attribute_values(*args)
      args.each_with_object([]) do |value, tags|
        case value
        when Hash
          value.each { |k, v| tags << k.to_s if v }
        when Array
          tags.concat flatten_attribute_values(*value)
        else
          tags << value.to_s if value.present?
        end
      end
    end

    def update_with_single_argument(other_hash, block)
      update_block = ->(key, old_value, new_value) { update_single_attribute(key, old_value, new_value, &block) }
      super(other_hash, update_block)
    end

    def update_single_attribute(key, old_value, new_value, &block)
      if key == "class"
        config.classname_merger.merge(old_value, new_value)
      elsif key == "data"
        config.stimulus_merger.merge(old_value, convert_value(new_value), &block)
      elsif block
        block.call(key, old_value, new_value)
      else
        new_value
      end
    end
  end
end
