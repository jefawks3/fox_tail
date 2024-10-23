# frozen_string_literal: true

module FoxTail
  class Translator
    attr_reader :model, :object_name, :method, :value, :scope, :default_value

    def initialize(object, object_name, method, options = {})
      @model = object.respond_to?(:to_model) ? object.to_model : nil
      @object_name = object_name.gsub(/\[(.*)_attributes\]\[\d+\]/, '.\1')
      @method = method
      @value = options[:value]
      @scope = options[:scope]
      @default_value = options.fetch(:default, "")
    end

    def translate
      return default_value if method.blank?

      defaults = []

      object_scopes.each do |object_scope|
        method_scopes.each do |method_scope|
          defaults << [object_scope, method_scope].compact_blank.join(".").to_sym
        end
      end

      defaults << method.to_sym
      defaults << default_value

      I18n.t(defaults.shift, default: defaults, scope: scope).presence
    end

    def to_s
      translate
    end

    private

    def object_scopes
      objects = []
      objects << object_name if object_name.present?
      objects << model.model_name.i18n_key if model
      objects << nil
      objects
    end

    def method_scopes
      value.present? ? ["#{method}.#{value}", "#{method}/#{value}", method] : [method]
    end
  end
end
