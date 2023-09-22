# frozen_string_literal: true

class Flowbite::TimelineComponent < Flowbite::BaseComponent
  renders_many :entries, lambda { |options = {}|
    options[:vertical] = vertical?
    Flowbite::Timeline::EntryComponent.new options
  }

  has_option :vertical, type: :boolean, default: true

  def render?
    entries?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :ol, html_attributes do
      entries.each { |entry| concat entry }
    end
  end
end
