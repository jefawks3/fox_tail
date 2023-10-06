# frozen_string_literal: true

# @logical_path components
# @component FoxTail::SpinnerComponent
class SpinnerComponentPreview < ViewComponent::Preview

  # @param color select { choices: [default,blue,red,green,yellow,indigo,purple,pink] }
  # @param size select { choices: [xs,sm,base,lg,xl] }
  def playground(color: :default, size: :base)
    render FoxTail::SpinnerComponent.new(color: color, size: size)
  end

  # @!group Sizes

  def extra_small
    render FoxTail::SpinnerComponent.new(size: :xs)
  end

  def small
    render FoxTail::SpinnerComponent.new(size: :sm)
  end

  def base
    render FoxTail::SpinnerComponent.new(size: :base)
  end

  def large
    render FoxTail::SpinnerComponent.new(size: :lg)
  end

  def extra_large
    render FoxTail::SpinnerComponent.new(size: :lg)
  end

  # @!endgroup

  # @!group Theme

  def default
    render FoxTail::SpinnerComponent.new(color: :default)
  end

  def neutral
    render FoxTail::SpinnerComponent.new(color: :neutral)
  end

  def blue
    render FoxTail::SpinnerComponent.new(color: :blue)
  end

  def red
    render FoxTail::SpinnerComponent.new(color: :red)
  end

  def green
    render FoxTail::SpinnerComponent.new(color: :green)
  end

  def yellow
    render FoxTail::SpinnerComponent.new(color: :yellow)
  end

  def indigo
    render FoxTail::SpinnerComponent.new(color: :indigo)
  end

  def purple
    render FoxTail::SpinnerComponent.new(color: :purple)
  end

  def pink
    render FoxTail::SpinnerComponent.new(color: :pink)
  end

  # @!endgroup
end
