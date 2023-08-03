# frozen_string_literal: true

class Flowbite::IconButtonComponent < Flowbite::ButtonBaseComponent
  attr_reader :icon

  def initialize(icon, html_attributes = {})
    @icon = icon
    super(html_attributes)
  end

  def call
    super do
      concat render_icon
      concat content_tag(:span, content, class: theme.classname("content.base")) if content?
    end
  end

  private

  def render_icon
    classes = classnames theme.classname("icon.base"), theme.classname([:icon, :size, size])
    render(Flowbite::IconBaseComponent.new(icon, class: classes))
  end
end
