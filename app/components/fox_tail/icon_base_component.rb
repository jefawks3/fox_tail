# frozen_string_literal: true

class FoxTail::IconBaseComponent < FoxTail::InlineSvgComponent
  attr_reader :name

  has_option :variant, default: :solid

  def initialize(name, html_attributes = {})
    @name = name.to_s.gsub("_", "-")
    super nil, html_attributes
  end

  def path
    icon_fullpath
  end

  private

  def icon_fullpath
    filename = "#{name.to_s.gsub("_", "-")}.svg"
    size = variant.to_sym == :mini ? "20" : "24"
    style = variant.to_sym == :mini ? "solid" : variant.to_s
    FoxTail.root.join("app/assets/vendor/heroicons", size, style, filename).to_s
  end
end
