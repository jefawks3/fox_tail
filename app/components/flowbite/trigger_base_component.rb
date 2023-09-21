# frozen_string_literal: true

class Flowbite::TriggerBaseComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController

  attr_reader :id, :selector, :block

  has_option :trigger_type

  def initialize(id, selector, html_attributes = {}, &block)
    super(html_attributes)
    @id = id
    @selector = selector
    @block = block
  end

  def block?
    !!block
  end

  def before_render
    super

    html_attributes[:id] = id
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
