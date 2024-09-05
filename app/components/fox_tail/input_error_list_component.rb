# frozen_string_literal: true

class FoxTail::InputErrorListComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable

  renders_many :messages, lambda { |text_or_attributes = {}, attributes = {}, &block|
    if block
      attributes = text_or_attributes
      text_or_attributes = capture(self, &block)
    end

    attributes[:class] = classnames theme.apply(:message, self), attributes[:class]
    content_tag :li, text_or_attributes, attributes
  }

  def initialize(html_attributes = {})
    if (aliases = html_attributes.delete(:aliases)).present?
      html_attributes[:errors_for] = Array(html_attributes[:errors_for]) + Array(aliases)

      FoxTail.deprecator.allow ["aliases"] do
        callstack = Array(caller_locations[slot ? 7 : 4])
        FoxTail.deprecator.warn "The `aliases` option has been deprecated. Use `errors_for` instead.", callstack
      end
    end

    super(html_attributes)
  end

  def render?
    messages? || error_messages.present?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    error_messages.each { |msg| with_message msg } unless messages?
  end

  def call
    content_tag :ul, html_attributes do
      messages.each { |msg| concat msg }
    end
  end

  private

  def error_messages
    @error_messages ||= object? && method_name? ? retrieve_errors : []
  end

  def retrieve_errors
    object = convert_to_model self.object
    messages = object_errors_for.each_with_object([]) do |attr, results|
      results.concat object.errors[attr] if object.errors[attr].present?
    end

    messages.uniq
  end
end
