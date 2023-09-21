# frozen_string_literal: true

module Flowbite::Concerns::Placeholderable
  extend ActiveSupport::Concern

  included do
    has_option :placeholder
  end

  def placeholder?
    !!placeholder.presence
  end

  def before_render
    super

    html_attributes[:placeholder] = retrieve_placeholder if placeholder?
  end

  protected

  def retrieve_placeholder
    return placeholder if placeholder.is_a? String
    return nil unless object_name? && method_name?

    value = placeholder unless placeholder.is_a? TrueClass
    placeholder_translator(value: value).translate || default_placeholder
  end

  def default_placeholder
    object = convert_to_model self.object
    return object.class.human_attribute_name(method_name) if object.class.respond_to?(:human_attribute_name)

    method_name&.humanize
  end

  def placeholder_translator(value: nil)
    translator value: value, scope: "helpers.placeholder"
  end
end
