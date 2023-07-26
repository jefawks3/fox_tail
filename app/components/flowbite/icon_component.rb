# frozen_string_literal: true

##
# Displays an icon inline
# @param [String, Symbol] icon The name of the Heroicon
# @param [Hash] html_attributes A hash with the html options
# @option html_attributes [Symbol] :variant The type of icon
# @option html_attributes [Symbol] :size The size of icon defined in the theme
# @option html_attributes [Symbol] :color The color of icon defined in the theme
# @option html_attributes [Hash] :theme A hash with the theme overrides
#
# Default options are:
#    :variant => :solid
class Flowbite::IconComponent < Flowbite::IconBaseComponent
  attr_reader :color, :size

  def initialize(name, color: :default, size: :base, **html_attributes)
    @color = color
    @size = size
    super name, **html_attributes
  end

  def call
    super do |doc|
      doc.child[:class] = base_classnames
    end
  end

  protected

  def base_classnames
    classnames theme.classname([:root, :color, color]),
               theme.classname([:root, :size, size]),
               html_attributes[:class]
  end
end
