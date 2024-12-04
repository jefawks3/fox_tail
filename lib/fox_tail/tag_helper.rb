# frozen_string_literal: true

module FoxTail
  module TagHelper
    def fox_tail
      @fox_tail ||= ComponentBuilder.new(self)
    end

    class ComponentBuilder
      def initialize(view_context)
        @view_context = view_context
      end

      def component_string(name, content = nil, *args, **options, &block)
        component = component_for(name).new(*args, **options)
        component.with_content(content) if content.present?

        @view_context.render(component, &block)
      end

      def component_for(name)
        "FoxTail::#{name.to_s.camelize}Component".safe_constantize
      end

      def form_for(record, controlled: false, **options, &block)
        options[:builder] ||= FoxTail::FormBuilder

        wrap_form(controlled, options) do |controller, form_options|
          @view_context.form_for(record, form_options) do |form|
            define_form_controller(form, controller)
            @view_context.capture(form, &block)
          end
        end
      end

      def form_with(controlled: false, **options, &block)
        options[:builder] ||= FoxTail::FormBuilder

        wrap_form(controlled, options) do |controller, form_options|
          @view_context.form_with(**form_options) do |form|
            define_form_controller(form, controller)
            @view_context.capture(form, &block)
          end
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        component_for(method_name) || super
      end

      def method_missing(method_name, *args, **options, &block)
        if component_for(method_name)
          component_string(method_name, nil, *args, **options, &block)
        else
          super
        end
      end

      private

      def wrap_form(controlled, options)
        return yield(nil, options) unless controlled

        @view_context.render FoxTail::FormControllerComponent.new(options) do |wrapper|
          yield(wrapper.form_controller, wrapper.html_attributes.deep_symbolize_keys)
        end
      end

      def define_form_controller(form, controller)
        form.define_singleton_method(:form_controller) { controller }
        form.define_singleton_method(:controlled?) { !!controller }
      end
    end
  end
end
