# frozen_string_literal: true

module Flowbite::Concerns::HasOptions
  extend ActiveSupport::Concern

  def options
    @options ||= self.class.default_options
  end

  def extract_options!(options = {})
    @options = options.extract!(*registered_options.keys).reverse_merge(self.class.default_options)
  end

  included do
    class_attribute :registered_options, instance_writer: false, instance_predicate: false
    self.registered_options = {}
  end

  class_methods do
    def default_options
      registered_options.deep_dup
    end

    def has_option(name, as: name, default: nil, type: nil, &option_block)
      self.registered_options = registered_options.merge name => default

      define_method as do
        options[name] = default unless options.key? name
        options[name]
      end

      define_method :"#{as}?" do
        if type == :boolean
          !!options[name]
        else
          options[name].present?
        end
      end

      define_method :"with_#{as}" do |value = nil, &setter_block|
        options[name] = if option_block
                          instance_exec(options[:name], value, setter_block, &option_block)
                        else
                          setter_block ? instance_exec(options[:name], &setter_block) : value
                        end

        self
      end
    end
  end
end