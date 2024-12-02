# frozen_string_literal: true

class FoxTail::TextareaComponent < FoxTail::InputBaseComponent
  has_option :autoresize, type: :boolean, default: false

  stimulated_with [:fox_tail, :textarea_auto_resize], as: :autoresize, if: :autoresize?

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :textarea, object_name? ? value_from_object : content, html_attributes
  end
end
