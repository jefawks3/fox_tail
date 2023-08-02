# frozen_string_literal: true

class IconComponentPreview < ViewComponent::Preview
  # Icon Playground
  # ----------------
  # See [heroicons.com](https://heroicons.com/) for a full list of available icons
  #
  # @param icon "The Heroicon name"
  # @param variant select { choices: [solid,outline,mini] } "The type of icon"
  # @param size select { choices: [xs,sm,base,lg,xl] } "The size of the icon"
  # @param color "The theme color of the icon"
  def playground(icon: "shield-check", variant: :solid, size: :base, color: :default)
    render(Flowbite::IconComponent.new(icon, variant: variant, size: size, color: color))
  end

  # @!group Theme

  # @label Neutral (Default)
  def neutral
    render(Flowbite::IconComponent.new("shield-check", color: :neutral))
  end

  def dark
    render(Flowbite::IconComponent.new("shield-check", color: :dark))
  end

  def light
    render(Flowbite::IconComponent.new("shield-check", color: :light))
  end

  def blue
    render(Flowbite::IconComponent.new("shield-check", color: :blue))
  end

  def red
    render(Flowbite::IconComponent.new("shield-check", color: :red))
  end

  def green
    render(Flowbite::IconComponent.new("shield-check", color: :green))
  end

  def yellow
    render(Flowbite::IconComponent.new("shield-check", color: :yellow))
  end

  def indigo
    render(Flowbite::IconComponent.new("shield-check", color: :indigo))
  end

  def purple
    render(Flowbite::IconComponent.new("shield-check", color: :purple))
  end

  def pink
    render(Flowbite::IconComponent.new("shield-check", color: :pink))
  end

  def info
    render(Flowbite::IconComponent.new("shield-check", color: :info))
  end

  def success
    render(Flowbite::IconComponent.new("shield-check", color: :success))
  end

  def warning
    render(Flowbite::IconComponent.new("shield-check", color: :warning))
  end

  def error
    render(Flowbite::IconComponent.new("shield-check", color: :error))
  end

  # @!endgroup

  # @!group Variants

  # Solid Icon
  # ---------------
  # *24x24, Solid fill*
  #
  # Useful for primary navigation and marketing sections.
  #
  # @label Solid (Default)
  def solid
    render(Flowbite::IconComponent.new("shield-check", variant: :solid))
  end

  # Outline Icon
  # ---------------
  # *24x24, 1.5px stroke*
  #
  # Useful for primary navigation and marketing sections.
  def outline
    render(Flowbite::IconComponent.new("shield-check", variant: :outline))
  end

  # Mini Icon
  # ---------------
  # *20x20, Solid fill*
  #
  # Useful for smaller elements like buttons, form elements, and to support text.
  def mini
    render(Flowbite::IconComponent.new("shield-check", variant: :mini))
  end

  # @!endgroup

  # @!group Sizes

  # @label Extra Small
  def xs
    render(Flowbite::IconComponent.new("shield-check", size: :xs))
  end

  # @label Small
  def sm
    render(Flowbite::IconComponent.new("shield-check", size: :sm))
  end

  # @label Base (Default)
  def base
    render(Flowbite::IconComponent.new("shield-check", size: :base))
  end

  # @label Large
  def lg
    render(Flowbite::IconComponent.new("shield-check", size: :lg))
  end

  # @label Extra Large
  def xl
    render(Flowbite::IconComponent.new("shield-check", size: :xl))
  end

  # @!endgroup

end
