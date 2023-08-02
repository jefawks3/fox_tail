# frozen_string_literal: true

class AvatarComponentPreview < ViewComponent::Preview
  # @param image "The image asset path or URI to display for the avatar."
  # @param size select { choices: [xs,sm,base,lg,xl] } "The size of the avatar."
  # @param rounded toggle "A circular avatar."
  def image(image: "users/michael-gough.png", size: :base, rounded: false)
    render(Flowbite::AvatarComponent.new(src: image, size: size, rounded: rounded))
  end

  # @param name "The Heroicon name. See https://heroicons.com/"
  # @param size select { choices: [xs,sm,base,lg,xl] } "The size of the avatar."
  # @param rounded toggle "A circular avatar"
  def icon(name: "user", size: :base, rounded: false)
    render(Flowbite::AvatarComponent.new(icon: name, size: size, rounded: rounded))
  end

  # @param text "The text to display in the Avatar."
  # @param size select { choices: [xs,sm,base,lg,xl] } "The size of the avatar."
  # @param rounded toggle "A circular avatar"
  def text(text: "TT", size: :base, rounded: false)
    render(Flowbite::AvatarComponent.new(text: text, size: size, rounded: rounded))
  end

  # @param color "The theme color to use for the dot. See Dot component documentation."
  # @param animated toggle "Animate the dot."
  # @param position select { choices: [top_left,top_right,top_center,center_left,center,center_right,bottom_left,bottom_center,bottom_right] } "The position of the dot."
  # @param size select { choices: [xs,sm,base,lg,xl] } "The size of the avatar."
  # @param rounded toggle "A circular avatar"
  def with_dot(size: :base, rounded: false, color: :green, animated: false, position: :top_right)
    render(Flowbite::AvatarComponent.new(src: "users/michael-gough.png", size: size, rounded: rounded)) do |c|
      c.with_dot position: position, color: color, animated: animated
    end
  end
end
