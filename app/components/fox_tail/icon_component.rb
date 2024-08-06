# frozen_string_literal: true

##
# Displays an icon inline
class FoxTail::IconComponent < FoxTail::IconBaseComponent
  attr_reader :color, :size

  has_option :color, default: :default
  has_option :size, default: :base
  has_option :shape, default: :none

  def shape?
    shape != "none"
  end

  def call
    if shape?
      content_tag :div, super, class: theme.apply(:container, self)
    else
      super
    end
  end

  protected

  def html_class
    classnames theme.apply(:root, self), super
  end
end
