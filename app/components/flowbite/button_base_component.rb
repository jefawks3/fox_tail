# frozen_string_literal: true

class Flowbite::ButtonBaseComponent < Flowbite::ClickableComponent
  has_option :variant, default: :solid
  has_option :size, default: :base
  has_option :color, default: :default
  has_option :pill, default: false, type: :boolean

  protected

  def root_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :size, size]),
               theme.classname([:root, variant, :base]),
               theme.classname([:root, variant, color]),
               pill? && theme.classname("root.pill"),
               disabled? && disabled_classes,
               block_given? && yield,
               html_class
  end

  def active_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :size, size]),
               theme.classname([:root, variant, :base]),
               theme.classname([:root, variant, color]),
               pill? && theme.classname("root.pill"),
               block_given? && yield,
               html_class
  end

  def disabled_classes
    classnames theme.classname("root.disabled.base"),
               theme.classname([:root, :disabled, variant, :base]),
               theme.classname([:root, :disabled, variant, color]),
               block_given? && yield
  end
end
