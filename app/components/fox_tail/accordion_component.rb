# frozen_string_literal: true

class FoxTail::AccordionComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::HasStimulusController

  attr_reader :id

  renders_many :items, lambda { |id, title, options = {}|
    options[:flush] = flush?
    options[:theme] = theme.theme :item
    FoxTail::Accordion::ItemComponent.new id, title, options
  }

  has_option :always_open, default: false, type: :boolean
  has_option :flush, default: false, type: :boolean

  def initialize(id, html_attributes = {})
    @id = id
    super(html_attributes)
  end

  def render?
    items?
  end

  def before_render
    super

    html_attributes[:id] = id
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, html_attributes do
      items.each { |item| concat item }
    end
  end

  def stimulus_controller_options
    { always_open: always_open }
  end

  class StimulusController < FoxTail::StimulusController
    def attributes(options = {})
      attributes = super options
      attributes[:data][value_key(:always_open)] = options[:always_open]
      attributes
    end
  end
end
