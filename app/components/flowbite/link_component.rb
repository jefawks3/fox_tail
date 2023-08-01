# frozen_string_literal: true

class Flowbite::LinkComponent < Flowbite::ClickableComponent
  has_option :color, default: :default

  def initialize(url, html_attributes = {})
    super(html_attributes)
    with_url url
  end

  private

  def root_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :color, color]),
               disabled? && disabled_classes,
               html_class
  end

  def active_classes
    classnames theme.classname("root.base"), theme.classname([:root, :color, color]), html_class
  end

  def disabled_classes
    classnames theme.classname("root.disabled.base"), theme.classname([:root, :disabled, :color, color])
  end
end
