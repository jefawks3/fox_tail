# frozen_string_literal: true

class IconButtonComponentPreview < ViewComponent::Preview
  ICON = "arrow-right"

  def default
    render(Flowbite::IconButtonComponent.new(ICON).with_content("Button"))
  end

  def pills
    render(Flowbite::IconButtonComponent.new(ICON, pill: true).with_content("Button"))
  end

  %i[xs sm base lg xl].each do |size|
    define_method :"#{size}_button" do
      render(Flowbite::IconButtonComponent.new(ICON, size: size).with_content("Button"))
    end
  end

  %i[solid outline].each do |variant|
    %i[default neutral dark light blue green yellow red indigo purple pink info success warning error].each do |color|
      next if variant == :outline && %i[neutral light].include?(color)

      define_method :"#{variant}_#{color}_button" do
        render(Flowbite::IconButtonComponent.new(ICON, variant: variant, color: color).with_content("Button"))
      end

      define_method :"#{variant}_#{color}_disabled_button" do
        render(Flowbite::IconButtonComponent.new(ICON, variant: variant, color: color, disabled: true).with_content("Button"))
      end

      define_method :"#{variant}_#{color}_controlled_button" do
        render(Flowbite::IconButtonComponent.new(ICON, variant: variant, color: color, controlled: true).with_content("Button"))
      end
    end
  end
end
