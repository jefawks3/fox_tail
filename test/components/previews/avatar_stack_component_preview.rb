# frozen_string_literal: true

class AvatarStackComponentPreview < ViewComponent::Preview
  %w[xs sm base lg xl].each do |size|
    define_method :"#{size}_stack" do
      render(Flowbite::AvatarStackComponent.new(size: size)) do |c|
        c.with_avatar src: "users/bonnie-green.png"
        c.with_avatar src: "users/jese-leos.png"
        c.with_avatar icon: :user
        c.with_avatar src: "users/robert-brown.png"
        c.with_avatar text: "TT"
      end
    end

    define_method :"#{size}_stack_with_counter" do
      render(Flowbite::AvatarStackComponent.new(size: size)) do |c|
        c.with_avatar src: "users/bonnie-green.png"
        c.with_avatar src: "users/jese-leos.png"
        c.with_avatar icon: :user
        c.with_avatar src: "users/robert-brown.png"
        c.with_avatar text: "TT"
        c.with_counter "+99", url: "#"
      end
    end
  end
end
