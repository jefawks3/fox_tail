# frozen_string_literal: true

class FoxTail::FormActionsComponent < FoxTail::BaseComponent
  renders_many :actions, types: {
    submit: {
      as: :submit,
      renders: ->(text_or_options = {}, options = {}) {
        if text_or_options.is_a?(Hash)
          options = text_or_options
          text_or_options = nil
        end

        options[:type] = :submit
        options[:color] ||= :primary
        options[:variant] ||= :solid

        if form_controlled?
          options[:controlled] = true unless options.key?(:controlled)
          options[:form_controlled] ||= :loading
          options[:loadable] = true unless options.key?(:loadable) || options[:form_controlled] != :loading
        end

        component = FoxTail::ButtonComponent.new options
        component.with_content text_or_options if text_or_options.present?
        component
      }
    },
    reset: {
      as: :reset,
      renders: ->(text_or_options = {}, options = {}) {
        if text_or_options.is_a?(Hash)
          options = text_or_options
          text_or_options = nil
        end

        options[:type] = :submit
        options[:color] ||= :neutral
        options[:variant] ||= :outline

        if form_controlled?
          options[:form_controlled] ||= :disable
          options[:controlled] = true unless options.key?(:controlled)
        end

        component = FoxTail::ButtonComponent.new options
        component.with_content text_or_options if text_or_options.present?
        component
      }
    },
    button: {
      as: :button,
      renders: ->(text_or_options = {}, options = {}) {
        if text_or_options.is_a?(Hash)
          options = text_or_options
          text_or_options = nil
        end

        options[:form_controlled] ||= :disable if form_controlled?

        component = FoxTail::ButtonComponent.new options
        component.with_content text_or_options if text_or_options.present?
        component
      }
    },
    link: {
      as: :link,
      renders: ->(text_or_options = {}, options = {}) {
        if text_or_options.is_a?(Hash)
          options = text_or_options
          text_or_options = nil
        end

        options[:form_controlled] ||= :disable if form_controlled?

        component = FoxTail::LinkComponent.new options
        component.with_content text_or_options if text_or_options.present?
        component
      }
    }
  }

  has_option :form_controlled, type: :boolean, default: false

  def render?
    actions? || content?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, html_attributes do
      actions.each { |action| concat action }
      concat content if content?
    end
  end
end
