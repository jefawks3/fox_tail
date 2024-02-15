# frozen_string_literal: true

module FoxTail::Concerns::HasOptions
  extend ActiveSupport::Concern

  RESERVED_OPTIONS = [FoxTail::Theme::BASE_KEY.to_s].freeze

  def options
    @options ||= self.class.default_options
  end

  def extract_options!(options = {})
    options.extract!(*registered_options.keys).each do |k, v|
      self.options[k.to_sym] = v
    end
  end

  included do
    class_attribute :registered_options, instance_writer: false, instance_predicate: false
    self.registered_options = {}
  end

  class_methods do
    def default_options
      registered_options.reject { |_,v| v[:default].nil? }.transform_values { |v| v[:default] }
    end

    def has_option(name, as: name, default: nil, type: nil)
      raise FoxTail::ReservedOption.new(self, as) if RESERVED_OPTIONS.include?(as.to_s)

      register_option name, { name: name, as: as, default: default, type: type }
    end

    def include_options_from(klass, only: nil, except: nil)
      return unless klass.respond_to? :registered_options

      only = Array(only).map(&:to_sym) if only.present?
      except = Array(except).map(&:to_sym) if except.present?

      klass.registered_options.each do |k, v|
        if !registered_options.key?(k) && (only.nil? || only.include?(k)) && (except.nil? || !except.include?(k))
          register_option k, v
        end
      end

      define_method "#{klass.name.underscore.gsub("_component", "").gsub("/", "_")}_options" do
        options.slice(*klass.registered_options.keys)
      end
    end

    def extract_options(options = {})
      options.slice(*registered_options.keys)
    end

    private

    def register_option(name, option)
      self.registered_options = registered_options.merge name => option

      define_method option[:as] do
        options[name]
      end

      define_method :"#{option[:as]}?" do
        if option[:type] == :boolean
          !!send(option[:as])
        else
          send(option[:as]).present?
        end
      end
    end
  end
end
