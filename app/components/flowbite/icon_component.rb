# frozen_string_literal: true

##
# Displays an icon inline
class Flowbite::IconComponent < Flowbite::IconBaseComponent
  attr_reader :color, :size

  has_option :color, default: :default
  has_option :size, default: :base

  protected

  def html_class
    classnames theme.apply(:root, self), super
  end
end
