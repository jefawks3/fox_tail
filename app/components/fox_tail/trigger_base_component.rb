# frozen_string_literal: true

class FoxTail::TriggerBaseComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable
  include FoxTail::Concerns::HasStimulusController

  attr_reader :selector, :block

  has_option :trigger_type

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

  def block?
    !!block
  end

  def before_render
    super

    generate_unique_id
    html_attributes[:class] = html_class
  end

  def render?
    content? || block?
  end

  def call
    block? ? view_context.capture(self, &block) : content
  end

  def stimulus_controller_options
    {
      selector: selector,
      trigger_type: trigger_type
    }
  end
end
