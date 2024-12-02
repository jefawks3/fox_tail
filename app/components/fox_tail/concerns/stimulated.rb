# frozen_string_literal: true

module FoxTail::Concerns::Stimulated
  extend ActiveSupport::Concern

  included do
    class_attribute :stimulus_controllers,
      instance_writer: false,
      instance_predicate: false

    self.stimulus_controllers = ActiveSupport::HashWithIndifferentAccess.new
  end

  def before_render
    stimulus_controllers.values.each do |controller|
      next if stimulated.registered?(controller.identifier) || !controller.register?(self)

      stimulated.register(controller.identifier, options).tap do |builder|
        instance_exec builder, &controller.block if controller.block
      end
    end

    super
  end

  def stimulated
    @stimulated ||= FoxTail::StimulusManager.new(html_attributes)
  end


  class_methods do
    def stimulated_with(identifier, options = {}, &block)
      stimulus_controller = StimulusController.new(identifier, options, block)
      self.stimulus_controllers = stimulus_controllers.merge(stimulus_controller.identifier => stimulus_controller)

      define_method stimulus_controller.method_name do
        stimulated.with(identifier)
      end
    end
  end

  class StimulusController
    attr_reader :identifier, :options, :controller_options, :block

    def initialize(identifier, options, block)
      @identifier = FoxTail::StimulusBuilder.format_identifier(identifier)
      @options = options.extract!(:as, :register, :if, :unless)
      @options[:as] ||= @identifier.gsub("-", "_")
      @controller_options = options
      @block = block
    end

    def method_name
      "#{options[:as]}_controller"
    end

    def block?
      !!block
    end

    def register?(component)
      return false unless options.fetch(:register, true)

      if_value = options[:if] ? execute_or_call(options[:if], component) : true
      unless_value = options[:unless] ? execute_or_call(options[:unless], component) : false

      if_value && !unless_value
    end

    private

    def execute_or_call(value, component)
      if value.is_a? Proc
        component.instance_exec(&value)
      else
        component.send(value)
      end
    end
  end
end
