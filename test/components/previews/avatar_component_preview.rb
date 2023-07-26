# frozen_string_literal: true

class AvatarComponentPreview < ViewComponent::Preview

  def default
    render(Flowbite::AvatarComponent.new(src: "users/michael-gough.png"))
  end

  %i[xs sm base lg xl].each do |size|
    define_method :"#{size}_blank" do
      render(Flowbite::AvatarComponent.new(size: size))
    end

    define_method :"#{size}_avatar" do
      render(Flowbite::AvatarComponent.new(src: "users/michael-gough.png", size: size))
    end

    define_method :"#{size}_rounded_avatar" do
      render(Flowbite::AvatarComponent.new(src: "users/michael-gough.png", size: size, rounded: true))
    end

    define_method :"#{size}_icon" do
      render(Flowbite::AvatarComponent.new(icon: :user, size: size))
    end

    define_method :"#{size}_rounded_icon" do
      render(Flowbite::AvatarComponent.new(icon: :user, size: size, rounded: true))
    end

    define_method :"#{size}_text" do
      render(Flowbite::AvatarComponent.new(text: "TT", size: size))
    end

    define_method :"#{size}_rounded_text" do
      render(Flowbite::AvatarComponent.new(text: "TT", size: size, rounded: true))
    end
  end

  %i[top center bottom].each do |y|
    %i[left center right].each do |x|
      position = y == :center && x == :center ? :center : :"#{y}_#{x}"

      define_method :"avatar_with_dot_#{position}" do
        render(Flowbite::AvatarComponent.new(src: "users/michael-gough.png")) do |c|
          c.with_dot position: position, color: :green
        end
      end
    end
  end
end
