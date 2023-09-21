# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::CheckboxComponent
class CheckboxComponentPreview < ViewComponent::Preview

  # @param size select {choices: [sm,base,lg]}
  # @param color select {choices: [default,blue,red,green,yellow,indigo,purple,pink]}
  # @param checked toggle
  # @param disabled toggle
  def playground(size: :base, color: :default, checked: true, disabled: false)
    render Flowbite::CheckboxComponent.new(size: size, color: color, checked: checked, disabled: disabled)
  end

  # @!group Checked

  def unchecked
    render Flowbite::CheckboxComponent.new(checked: false)
  end

  def checked
    render Flowbite::CheckboxComponent.new(checked: true)
  end

  # @!endgroup

  # @!group Disabled

  def active
    render Flowbite::CheckboxComponent.new(disabled: false)
  end

  def disabled
    render Flowbite::CheckboxComponent.new(disabled: true)
  end

  # @!endgroup

  # @!group Sizes

  def small
    render Flowbite::CheckboxComponent.new(size: :sm)
  end

  # @label Base (Default)
  def base
    render Flowbite::CheckboxComponent.new(size: :base)
  end

  def large
    render Flowbite::CheckboxComponent.new(size: :lg)
  end

  # @!endgroup

  # @!group Colors

  def default
    render Flowbite::CheckboxComponent.new(color: :default, checked: true)
  end

  def blue
    render Flowbite::CheckboxComponent.new(color: :blue, checked: true)
  end

  def red
    render Flowbite::CheckboxComponent.new(color: :red, checked: true)
  end

  def green
    render Flowbite::CheckboxComponent.new(color: :green, checked: true)
  end

  def yellow
    render Flowbite::CheckboxComponent.new(color: :yellow, checked: true)
  end

  def indigo
    render Flowbite::CheckboxComponent.new(color: :indigo, checked: true)
  end

  def purple
    render Flowbite::CheckboxComponent.new(color: :purple, checked: true)
  end

  def pink
    render Flowbite::CheckboxComponent.new(color: :pink, checked: true)
  end

  # @!endgroup
end
