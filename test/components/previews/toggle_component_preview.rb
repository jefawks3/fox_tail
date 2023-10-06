# frozen_string_literal: true

# @logical_path forms
# @component FoxTail::ToggleComponent
class ToggleComponentPreview < ViewComponent::Preview

  # @param color select { choices: [default,blue,red,green,yellow,indigo,purple,pink] }
  # @param size select { choices: [sm,base,lg] }
  # @param disabled toggle
  # @param checked toggle
  def playground(color: :default, size: :base, disabled: false, checked: true)
    render FoxTail::ToggleComponent.new(color: color, size: size, disabled: disabled, checked: checked)
  end

  # @!group Sizes

  def small
    render FoxTail::ToggleComponent.new(size: :sm)
  end

  # @label Base (Default)
  def base
    render FoxTail::ToggleComponent.new(size: :base)
  end

  def large
    render FoxTail::ToggleComponent.new(size: :lg)
  end

  # @!endgroup

  # @!group Color

  def default
    render FoxTail::ToggleComponent.new(color: :default, checked: true)
  end

  def blue
    render FoxTail::ToggleComponent.new(color: :blue, checked: true)
  end

  def red
    render FoxTail::ToggleComponent.new(color: :red, checked: true)
  end

  def green
    render FoxTail::ToggleComponent.new(color: :green, checked: true)
  end

  def yellow
    render FoxTail::ToggleComponent.new(color: :yellow, checked: true)
  end

  def indigo
    render FoxTail::ToggleComponent.new(color: :indigo, checked: true)
  end

  def purple
    render FoxTail::ToggleComponent.new(color: :purple, checked: true)
  end

  def pink
    render FoxTail::ToggleComponent.new(color: :pink, checked: true)
  end

  # @!endgroup

  # @!group Checked

  def unchecked
    render FoxTail::ToggleComponent.new(checked: false)
  end

  def checked
    render FoxTail::ToggleComponent.new(checked: true)
  end

  # @!endgroup

  # @!group Disabled

  def active
    render FoxTail::ToggleComponent.new(disabled: false, checked: true)
  end

  def disabled
    render FoxTail::ToggleComponent.new(disabled: true, checked: true)
  end

  # @!endgroup
end
