# frozen_string_literal: true

class FoxTail::TriggerBaseComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable

  attr_reader :selector

  has_option :trigger_type
  has_option :identifier
  has_option :parent_identifier

  def initialize(id_or_selector, selector_or_attributes = {}, html_attributes = {}, &block)
    if selector_or_attributes.is_a? Hash
      html_attributes = selector_or_attributes
      selector_or_attributes = id_or_selector
    else
      __id_argument_deprecated_warning
      html_attributes[:id] = id_or_selector
    end

    super(html_attributes)
    @selector = selector_or_attributes
    @block = block
  end

  def identifier
    options[:identifier] ||= self.class.default_identifier
  end

  def parent_identifier
    options[:parent_identifier] ||= FoxTail::StimulusBuilder.format_identifier(identifier).gsub(/-trigger$/, "")
  end

  def trigger_controller
    stimulated.register(identifier) unless stimulated.registered?(identifier)
    stimulated.with(identifier)
  end

  def before_render
    super

    generate_unique_id
    html_attributes[:class] = html_class

    trigger_controller.with_outlet(parent_identifier, selector)
  end

  def call
    block? ? view_context.capture(self, &block) : content
  end

  protected

  def extract_controls(selector = self.selector)
    selector = selector&.to_s
    selector[1..] if selector.present? && selector.start_with?("#") && !selector.match?(/\s/)
  end

  private

  attr_reader :block

  def block?
    !!block
  end

  class << self
    def default_identifier
      name.gsub(/Component$/, "").underscore.split("/")
    end
  end
end
