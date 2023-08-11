# frozen_string_literal: true

class Flowbite::AccordionComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController

  attr_reader :id

  renders_many :items, lambda { |id, title, options = {}|
    options[:flush] = flush?
    Flowbite::Accordion::ItemComponent.new(id, title, options)
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
    html_attributes[:class] = html_class
  end

  def call
    content_tag :div, html_attributes do
      items.each_with_index { |item, index| concat render_item(item, index) }
    end
  end

  def stimulus_controller_options
    { always_open: always_open }
  end

  private

  def item_position(index)
    if index.zero?
      :start
    elsif index == items.length - 1
      :end
    else
      :middle
    end
  end

  def render_item(item, index)
    item.with_position item_position(index)
    item
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    def attributes(options = {})
      attributes = super options
      attributes[:data][value_key(:always_open)] = options[:always_open]
      attributes
    end
  end
end
