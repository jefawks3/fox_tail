# frozen_string_literal: true

# @component FoxTail::DotIndicatorComponent
# @logical_path components
class DotIndicatorComponentPreview < ViewComponent::Preview
  # @param color "The theme color of the dot"
  # @param size select {choices: [xs,sm,base,lg,xl]}
  # @param animated toggle "Add a pulsing animation."
  def playground(color: :default, animated: false, size: :base)
    render(FoxTail::DotIndicatorComponent.new(color: color, animated: animated, size: size))
  end

  # @!group Theme

  # @label Neutral (Default)
  def neutral
    render(FoxTail::DotIndicatorComponent.new(color: :neutral))
  end

  def dark
    render(FoxTail::DotIndicatorComponent.new(color: :dark))
  end

  def light
    render(FoxTail::DotIndicatorComponent.new(color: :light))
  end

  def blue
    render(FoxTail::DotIndicatorComponent.new(color: :blue))
  end

  def green
    render(FoxTail::DotIndicatorComponent.new(color: :green))
  end

  def yellow
    render(FoxTail::DotIndicatorComponent.new(color: :yellow))
  end

  def indigo
    render(FoxTail::DotIndicatorComponent.new(color: :indigo))
  end

  def purple
    render(FoxTail::DotIndicatorComponent.new(color: :purple))
  end

  def pink
    render(FoxTail::DotIndicatorComponent.new(color: :pink))
  end

  def info
    render(FoxTail::DotIndicatorComponent.new(color: :info))
  end

  def error
    render(FoxTail::DotIndicatorComponent.new(color: :danger))
  end

  def success
    render(FoxTail::DotIndicatorComponent.new(color: :success))
  end

  def warning
    render(FoxTail::DotIndicatorComponent.new(color: :warning))
  end

  # @!endgroup

  # @!group Animated

  # @label Neutral (Default)
  def neutral_animated
    render(FoxTail::DotIndicatorComponent.new(color: :neutral, animated: true))
  end

  # @label Dark
  def dark_animated
    render(FoxTail::DotIndicatorComponent.new(color: :dark, animated: true))
  end

  # @label Light
  def light_animated
    render(FoxTail::DotIndicatorComponent.new(color: :light, animated: true))
  end

  # @label Blue
  def blue_animated
    render(FoxTail::DotIndicatorComponent.new(color: :blue, animated: true))
  end

  # @label Green
  def green_animated
    render(FoxTail::DotIndicatorComponent.new(color: :green, animated: true))
  end

  # @label Yellow
  def yellow_animated
    render(FoxTail::DotIndicatorComponent.new(color: :yellow, animated: true))
  end

  # @label Indigo
  def indigo_animated
    render(FoxTail::DotIndicatorComponent.new(color: :indigo, animated: true))
  end

  # @label Purple
  def purple_animated
    render(FoxTail::DotIndicatorComponent.new(color: :purple, animated: true))
  end

  # @label Pink
  def pink_animated
    render(FoxTail::DotIndicatorComponent.new(color: :pink, animated: true))
  end

  # @label Info
  def info_animated
    render(FoxTail::DotIndicatorComponent.new(color: :info, animated: true))
  end

  # @label Error
  def danger_animated
    render(FoxTail::DotIndicatorComponent.new(color: :danger, animated: true))
  end

  # @label Success
  def success_animated
    render(FoxTail::DotIndicatorComponent.new(color: :success, animated: true))
  end

  # @label Warning
  def warning_animated
    render(FoxTail::DotIndicatorComponent.new(color: :warning, animated: true))
  end

  # @!endgroup

  # @!group Sizes

  def extra_small
    render(FoxTail::DotIndicatorComponent.new(size: :xs))
  end

  def small
    render(FoxTail::DotIndicatorComponent.new(size: :sm))
  end

  # @label Base (Default)
  def base
    render(FoxTail::DotIndicatorComponent.new(size: :base))
  end

  def large
    render(FoxTail::DotIndicatorComponent.new(size: :lg))
  end

  def extra_large
    render(FoxTail::DotIndicatorComponent.new(size: :xl))
  end

  # @!endgroup
end
