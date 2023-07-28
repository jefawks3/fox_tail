# frozen_string_literal: true

class Flowbite::IconBaseComponent < Flowbite::InlineSvgComponent
  attr_reader :name, :variant

  def initialize(name, variant: :solid, **html_attributes)
    @name = name.to_s.gsub("_", "-")
    @variant = variant
    super(icon_fullpath, html_attributes)
  end

  private

  def icon_fullpath
    filename = "#{name.to_s.gsub("_", "-")}.svg"
    size = variant == :mini ? "20" : "24"
    style = variant == :mini ? "solid" : variant.to_s
    Flowbite::ViewComponents.root.join("app/assets/vendor/heroicons", size, style, filename).to_s
  end
end
