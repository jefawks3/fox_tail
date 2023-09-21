# frozen_string_literal: true

# ViewComponents version agnostic safe Just-In-Time Rendering component wrapper used to pass updated options to
#   child or slot components.
class Flowbite::WrapperComponent < ViewComponent::Base
  attr_reader :options, :block

  def initialize(options = {}, &block)
    super()
    @options = options
    @block = block
  end

  alias_method :html_attributes, :options

  def with_html_attributes(attributes)
    options.merge! attributes if attributes.present?
    self
  end

  def html_class
    options[:class]
  end

  def with_html_class(classes)
    options[:class] = self.class.classname_merger.merge html_class, classes
    self
  end

  def block?
    block.present?
  end

  def render?
    content? || block?
  end

  def call
    if block?
      view_context.capture self, &block
    else
      content
    end
  end

  class << self
    def classname_merger
      Flowbite::ViewComponents::Base.flowbite_config.classname_merger
    end
  end
end
