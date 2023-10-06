# frozen_string_literal: true

class FoxTail::LabelComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable

  has_option :state
  has_option :required, type: :boolean, default: false
  has_option :value

  def before_render
    super

    update_state_from_object!
    html_attributes[:for] ||= tag_id_for_value value
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :label, retrieve_content, html_attributes
  end

  private

  def retrieve_content
    return content if content?
    return unless object_name? && method_name?

    label_translator.translate || default_label
  end

  def default_label
    object = convert_to_model self.object
    return object.class.human_attribute_name(method_name) if object.class.respond_to?(:human_attribute_name)

    method_name&.humanize
  end

  def label_translator(value: self.value, default: "")
    translator value: value, default: default, scope: "helpers.label"
  end

  def update_state_from_object!
    return unless object? && !options.key(:state)

    options[:state] = if object_errors?
                        :invalid
                      elsif html_attributes[:value].present?
                        :valid
                      else
                        :none
                      end
  end
end
