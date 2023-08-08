# frozen_string_literal: true

class Flowbite::Accordion::ItemComponent < Flowbite::BaseComponent
  attr_reader :title

  renders_one :icon
  renders_one :arrow

  has_option :flush, default: false, type: :boolean

  def initialize(title, html_attributes = {})
    @title = title
    super(html_attributes)
  end
end
