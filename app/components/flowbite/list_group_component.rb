# frozen_string_literal: true

class Flowbite::ListGroupComponent < Flowbite::BaseComponent
  renders_many :items, lambda { |options = {}|
    options[:flush] = flush?
    options[:theme] = theme.theme :item
    Flowbite::ListGroup::ItemComponent.new options
  }

  has_option :flush, type: :boolean, default: false

  def render?
    items?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, html_attributes do
      items.each { |item| concat item }
    end
  end
end
