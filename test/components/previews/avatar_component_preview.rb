# frozen_string_literal: true

# @component FoxTail::AvatarComponent
# @logical_path components
class AvatarComponentPreview < ViewComponent::Preview
  # @param image "The image asset path or URI to display for the avatar."
  # @param icon "The heroicon to use for the avatar when image is empty"
  # @param text "The placeholder text to use when image & icon are empty"
  # @param size select { choices: [xs,sm,base,lg,xl] } "The size of the avatar."
  # @param rounded toggle "A circular avatar."
  # @param border toggle "Add a border around the avatar"
  # @param indicator toggle "Show indicator"
  # @param indicator_position select { choices: [top_left,top_center,top_right,center_left,center,center_right,bottom_left,bottom_center,bottom_right] } "The position of the indicator"
  # @param indicator_color "The theme color of the Dot Indicator"
  # @param indicator_animated toggle "Animate the indicator with a pulse"
  def playground(image: "users/michael-gough.png", icon: "user", text: "TT", size: :base, rounded: false, border: false, indicator: false, indicator_position: :top_right, indicator_color: :green, indicator_animated: false)
    render(FoxTail::AvatarComponent.new(src: image, icon: icon, text: text, size: size, rounded: rounded, border: border)) do |c|
      c.with_dot position: indicator_position, color: indicator_color, animated: indicator_animated if indicator.present?
    end
  end

  # @!group Sizes

  # @label Extra Small
  def xs
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png", size: :xs))
  end

  # @label Small
  def sm
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png", size: :sm))
  end

  # @label Base (Default)
  def base
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png", size: :base))
  end

  # @label Large
  def lg
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png", size: :lg))
  end

  # @label Extra Large
  def xl
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png", size: :lg))
  end

  # @!endgroup

  # @!group Styles

  def default
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png"))
  end

  def rounded
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png", rounded: true))
  end

  def bordered
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png", border: true))
  end

  # @!endgroup

  # @!group Indicator Position

  # @label Top Left
  def indicator_top_left
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png")) do |c|
      c.with_dot position: :top_left
    end
  end

  # @label Top Center
  def indicator_top_center
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png")) do |c|
      c.with_dot position: :top_center
    end
  end

  # @label Top Right
  def indicator_top_right
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png")) do |c|
      c.with_dot position: :top_right
    end
  end

  # @label Center Left
  def indicator_center_left
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png")) do |c|
      c.with_dot position: :center_left
    end
  end

  # @label Center
  def indicator_center
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png")) do |c|
      c.with_dot position: :center
    end
  end

  # @label Center Right
  def indicator_center_right
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png")) do |c|
      c.with_dot position: :center_right
    end
  end

  # @label Bottom Left
  def indicator_bottom_left
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png")) do |c|
      c.with_dot position: :bottom_left
    end
  end

  # @label Bottom Center
  def indicator_bottom_center
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png")) do |c|
      c.with_dot position: :bottom_center
    end
  end

  # @label Top Left
  def indicator_bottom_right
    render(FoxTail::AvatarComponent.new(src: "users/michael-gough.png")) do |c|
      c.with_dot position: :bottom_right
    end
  end

  # @!endgroup
end
