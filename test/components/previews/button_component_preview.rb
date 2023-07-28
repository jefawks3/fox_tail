# frozen_string_literal: true

class ButtonComponentPreview < ViewComponent::Preview
  def default
    render(Flowbite::ButtonComponent.new.with_content("Button"))
  end

  def pills
    render(Flowbite::ButtonComponent.new(pill: true).with_content("Button"))
  end

  def loading
    render(Flowbite::ButtonComponent.new(loading: true).with_content("Button"))
  end

  def loading_controlled
    render(Flowbite::ButtonComponent.new(loadable: true, controlled: true)) do |c|
      c.with_left_icon "shopping-cart"
      c.with_right_icon "arrow-right"
      "Button"
    end
  end

  def loading_controlled_with_label
    render(Flowbite::ButtonComponent.new(loadable: true, controlled: true)) do |c|
      c.with_loading_label.with_content("Loading ...")
      c.with_left_icon "shopping-cart"
      c.with_right_icon "arrow-right"
      "Button"
    end
  end

  %i[xs sm base lg xl].each do |size|
    define_method :"#{size}_button" do
      render(Flowbite::ButtonComponent.new(size: size).with_content("Button"))
    end

    define_method :"#{size}_button_with_left_icon" do
      render(Flowbite::ButtonComponent.new(size: size)) do |c|
        c.with_left_icon "shopping-cart"
        "Button"
      end
    end

    define_method :"#{size}_button_with_right_icon" do
      render(Flowbite::ButtonComponent.new(size: size)) do |c|
        c.with_right_icon "arrow-right"
        "Button"
      end
    end
  end

  %i[solid outline].each do |variant|
    %i[default neutral dark light blue green yellow red indigo purple pink info success warning error].each do |color|
      next if variant == :outline && %i[neutral light].include?(color)

      define_method :"#{variant}_#{color}_button" do
        render(Flowbite::ButtonComponent.new(variant: variant, color: color).with_content("Button"))
      end

      define_method :"#{variant}_#{color}_disabled_button" do
        render(Flowbite::ButtonComponent.new(variant: variant, color: color, disabled: true).with_content("Button"))
      end

      define_method :"#{variant}_#{color}_controlled_button" do
        render(Flowbite::ButtonComponent.new(variant: variant, color: color, controlled: true).with_content("Button"))
      end
    end
  end
end
