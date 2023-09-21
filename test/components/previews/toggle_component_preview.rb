# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::ToggleComponent
class ToggleComponentPreview < ViewComponent::Preview

  # @param color select { choices: [default,blue,red,green,yellow,indigo,purple,pink] }
  # @param size select { choices: [sm,base,lg] }
  # @param disabled toggle
  # @param checked toggle
  def playground(color: :default, size: :base, disabled: false, checked: true)
    render Flowbite::ToggleComponent.new(color: color, size: size, disabled: disabled, checked: checked)
  end

  # @!group Sizes

  def small
    render Flowbite::ToggleComponent.new(size: :sm)
  end

  # @label Base (Default)
  def base
    render Flowbite::ToggleComponent.new(size: :base)
  end

  def large
    render Flowbite::ToggleComponent.new(size: :lg)
  end

  # @!endgroup

  # @!group Color

  def default
    render Flowbite::ToggleComponent.new(color: :default, checked: true)
  end

  def blue
    render Flowbite::ToggleComponent.new(color: :blue, checked: true)
  end

  def red
    render Flowbite::ToggleComponent.new(color: :red, checked: true)
  end

  def green
    render Flowbite::ToggleComponent.new(color: :green, checked: true)
  end

  def yellow
    render Flowbite::ToggleComponent.new(color: :yellow, checked: true)
  end

  def indigo
    render Flowbite::ToggleComponent.new(color: :indigo, checked: true)
  end

  def purple
    render Flowbite::ToggleComponent.new(color: :purple, checked: true)
  end

  def pink
    render Flowbite::ToggleComponent.new(color: :pink, checked: true)
  end

  # @!endgroup

  # @!group Checked

  def unchecked
    render Flowbite::ToggleComponent.new(checked: false)
  end

  def checked
    render Flowbite::ToggleComponent.new(checked: true)
  end

  # @!endgroup

  # @!group Disabled

  def active
    render Flowbite::ToggleComponent.new(disabled: false, checked: true)
  end

  def disabled
    render Flowbite::ToggleComponent.new(disabled: true, checked: true)
  end

  # @!endgroup
end
