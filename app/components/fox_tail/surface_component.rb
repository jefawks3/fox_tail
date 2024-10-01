# frozen_string_literal: true

class FoxTail::SurfaceComponent < FoxTail::ClickableComponent
  has_option :border, type: :boolean, default: true
  has_option :tag_name, default: :div
  has_option :hover, type: :boolean, default: false

  def root_tag_name
    link? ? :a : tag_name
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag root_tag_name, content, html_attributes
  end
end
