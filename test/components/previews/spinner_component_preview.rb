# frozen_string_literal: true

# @logical_path components
# @component Flowbite::SpinnerComponent
class SpinnerComponentPreview < ViewComponent::Preview

  # @param color select { choices: [default,blue,red,green,yellow,indigo,purple,pink] }
  # @param size select { choices: [xs,sm,base,lg,xl] }
  def playground(color: :default, size: :base)
    render Flowbite::SpinnerComponent.new(color: color, size: size)
  end

  # @!group Sizes

  def extra_small
    render Flowbite::SpinnerComponent.new(size: :xs)
  end

  def small
    render Flowbite::SpinnerComponent.new(size: :sm)
  end

  def base
    render Flowbite::SpinnerComponent.new(size: :base)
  end

  def large
    render Flowbite::SpinnerComponent.new(size: :lg)
  end

  def extra_large
    render Flowbite::SpinnerComponent.new(size: :lg)
  end

  # @!endgroup

  # @!group Theme

  def default
    render Flowbite::SpinnerComponent.new(color: :default)
  end

  def neutral
    render Flowbite::SpinnerComponent.new(color: :neutral)
  end

  def blue
    render Flowbite::SpinnerComponent.new(color: :blue)
  end

  def red
    render Flowbite::SpinnerComponent.new(color: :red)
  end

  def green
    render Flowbite::SpinnerComponent.new(color: :green)
  end

  def yellow
    render Flowbite::SpinnerComponent.new(color: :yellow)
  end

  def indigo
    render Flowbite::SpinnerComponent.new(color: :indigo)
  end

  def purple
    render Flowbite::SpinnerComponent.new(color: :purple)
  end

  def pink
    render Flowbite::SpinnerComponent.new(color: :pink)
  end

  # @!endgroup
end
