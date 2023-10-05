# frozen_string_literal: true

class Flowbite::DialogComponent < Flowbite::SurfaceComponent
  renders_one :header, lambda { |options = {}, &block|
    options[:class] = classnames theme.apply(:header, self), options[:class]
    content_tag :div, options, &block
  }

  renders_one :body, lambda { |options = {}, &block|
    options[:class] = classnames theme.apply(:body, self), options[:class]
    content_tag :div, options, &block
  }

  renders_one :footer, lambda { |options = {}, &block|
    options[:class] = classnames theme.apply(:footer, self), options[:class]
    content_tag :div, options, &block
  }

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
end
