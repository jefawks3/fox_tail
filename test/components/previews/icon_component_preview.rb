# frozen_string_literal: true

class IconComponentPreview < ViewComponent::Preview
  ICON = "shield-check"

  def default
    render(Flowbite::IconComponent.new(ICON))
  end

  %i[solid outline mini].each do |variant|
    define_method :"#{variant}_icon" do
      render(Flowbite::IconComponent.new(ICON, variant: variant))
    end
  end

  %i[xs sm base lg xl].each do |size|
    define_method :"#{size}_icon" do
      render(Flowbite::IconComponent.new(ICON, size: size))
    end
  end

  %i[neutral dark light info success warning error red blue yellow green indigo purple pink].each do |color|
    define_method :"#{color}_icon" do
      render(Flowbite::IconComponent.new(ICON, color: color))
    end
  end
end
