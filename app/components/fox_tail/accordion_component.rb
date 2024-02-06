# frozen_string_literal: true

class FoxTail::AccordionComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::HasStimulusController
  include FoxTail::Concerns::Identifiable

  renders_many :items, lambda { |id_or_title, title_or_options = {}, options = {}|
    if title_or_options.is_a? Hash
      options = title_or_options
      title_or_options = id_or_title
    else
      options[:id] = id_or_title
      __id_argument_deprecated_warning slot: :item
    end

    options[:flush] = flush?
    options[:theme] = theme.theme :item
    options[:id] ||= "#{id}_item_#{SecureRandom.base58(6)}"
    FoxTail::Accordion::ItemComponent.new title_or_options, options
  }

  has_option :always_open, default: false, type: :boolean
  has_option :flush, default: false, type: :boolean

  def initialize(id_or_attributes = {}, html_attributes = {})
    if id_or_attributes.is_a? Hash
      html_attributes = id_or_attributes
    else
      __id_argument_deprecated_warning
      html_attributes[:id] = id_or_attributes
    end

    super html_attributes
  end

  def render?
    items?
  end

  def before_render
    super

    generate_unique_id
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
