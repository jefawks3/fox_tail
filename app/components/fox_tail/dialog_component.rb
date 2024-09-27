# frozen_string_literal: true

class FoxTail::DialogComponent < FoxTail::SurfaceComponent
  renders_one :header, lambda { |options = {}, &block|
    options[:class] = classnames theme.apply(:header, self), options[:class]
    content_tag :div, options, &block
  }

  renders_many :bodies, lambda { |options = {}, &block|
    options[:class] = classnames theme.apply(:body, self), options[:class]
    content_tag :div, options, &block
  }

  renders_one :footer, lambda { |options = {}, &block|
    options[:class] = classnames theme.apply(:footer, self), options[:class]
    content_tag :div, options, &block
  }

  has_option :wrap_content, type: :boolean, default: true

  def initialize(html_attributes = {})
    html_attributes[:border] = false unless html_attributes.key? :border
    super(html_attributes)
  end

  def hover?
    false
  end

  def tag_name
    :div
  end

  def formatted_content
    return nil unless content? && content.present?
    return content unless wrap_content?

    content_tag :div, content, class: theme.apply(:body, self)
  end
end
