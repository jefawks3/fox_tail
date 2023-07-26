# frozen_string_literal: true

class DotIndicatorComponentPreview < ViewComponent::Preview

  %i[default neutral dark light blue red green yellow indigo purple pink info error success warning].each do |color|
    define_method :"#{color}_dot" do
      render(Flowbite::DotIndicatorComponent.new(color: color))
    end

    define_method :"#{color}_animated_dot" do
      render(Flowbite::DotIndicatorComponent.new(color: color, animated: true))
    end
  end
end
