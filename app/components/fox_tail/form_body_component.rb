# frozen_string_literal: true

class FoxTail::FormBodyComponent < FoxTail::BaseComponent
  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, content, html_attributes
  end
end
