# frozen_string_literal: true

class LinkComponentPreview < ViewComponent::Preview
  %i[default neutral dark light red blue green yellow indigo purple pink info success warning error].each do |color|
    define_method :"#{color}_link" do
      render(Flowbite::LinkComponent.new("#", color: color).with_content("link"))
    end

    define_method :"#{color}_disabled_link" do
      render(Flowbite::LinkComponent.new("#", color: color, disabled: true).with_content("link"))
    end

    define_method :"#{color}_controlled_link" do
      render(Flowbite::LinkComponent.new("#", color: color, controlled: true).with_content("link"))
    end
  end
end
