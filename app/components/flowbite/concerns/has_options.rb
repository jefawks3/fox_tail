# frozen_string_literal: true

module Flowbite::Concerns::HasOptions
  extend ActiveSupport::Concern

  def options
    @options ||= self.class.default_options
  end

  def extract_options!(options = {})
    options.extract!(*registered_options.keys).each do |k, v|
      send registered_options[k][:setter], v
    end
  end

  included do
    class_attribute :registered_options, instance_writer: false, instance_predicate: false
    self.registered_options = {}
  end

  class_methods do
    def default_options
      registered_options.transform_values { |v| v[:default] }
    end

    def has_option(name, as: name, default: nil, type: nil, &option_block)
      self.registered_options = registered_options.merge name => { name: name, setter: :"with_#{as}", default: default }

      define_method as do
        options[name] = default unless options.key? name
        options[name]
      end

      define_method :"#{as}?" do
        if type == :boolean
          !!send(name)
        else
          send(name).present?
        end
      end

      define_method :"with_#{as}" do |value = nil, &setter_block|
        value = instance_exec options[:name], &setter_block if setter_block
        options[name] = option_block ? instance_exec(options[:name], value, &option_block) : value
        self
      end
    end
  end
end
