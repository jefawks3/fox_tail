# frozen_string_literal: true

class FoxTail::LinkComponent < FoxTail::ClickableComponent
  has_option :color, default: :default

  def initialize(url, html_attributes = {})
    super(html_attributes)
    @url = url
  end
end
