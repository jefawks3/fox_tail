# frozen_string_literal: true

class FoxTail::WrapperComponent < FoxTail::BaseComponent
  attr_reader :block

  def initialize(html_attributes = {}, &block)
    super(html_attributes)
    @block = block
  end

  def block?
    !!@block
  end

  def before_render
    super

    html_attributes[:class] = html_class
  end

  def render?
    block? || content?
  end

  def call
    block ? capture(self, &block) : content
  end
end
