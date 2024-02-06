# frozen_string_literal: true

class FoxTail::IconBaseComponent < FoxTail::InlineSvgComponent
  VARIANT_SIZES = { micro: 16, mini: 20, solid: 24, outline: 24 }.freeze
  SOLID_ONLY_VARIANTS = %i[micro mini].freeze

  attr_reader :name

  has_option :variant, default: :solid

  def initialize(name, html_attributes = {})
    @name = name.to_s.gsub("_", "-")
    super nil, html_attributes
  end

  def path
    FoxTail.root.join("app/assets/vendor/heroicons", icon_size.to_s, icon_style.to_s, icon_filename).to_s
  end

  def icon_size
    VARIANT_SIZES[variant.to_sym]
  end

  def icon_style
    return :solid if SOLID_ONLY_VARIANTS.include? variant.to_sym

    variant
  end

  def icon_filename
    "#{name}.svg"
  end
end
