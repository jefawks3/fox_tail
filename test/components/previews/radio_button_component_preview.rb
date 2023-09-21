# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::RadioButtonComponent
class RadioButtonComponentPreview < ViewComponent::Preview

  # @param checked toggle
  # @param disabled toggle
  # @param size select { choices: [sm,base,lg] }
  # @param color select { choices: [default,blue,red,green,yellow,indigo,purple,pink] }
  def playground(checked: true, disabled: false, color: :default, size: :base)
    render Flowbite::RadioButtonComponent.new(
      checked: checked,
      disabled: disabled,
      color: color,
      size: size,
      name: :test
    )
  end

  # @!group Checked

  def unchecked
    render Flowbite::RadioButtonComponent.new(checked: false, name: :test)
  end

  def checked
    render Flowbite::RadioButtonComponent.new(checked: true, name: :test)
  end

  # @!endgroup

  # @!group Disabled

  def active
    render Flowbite::RadioButtonComponent.new(disabled: false, name: :test)
  end

  def disabled
    render Flowbite::RadioButtonComponent.new(disabled: true, name: :test)
  end

  # @!endgroup

  # @!group Size

  def small
    render Flowbite::RadioButtonComponent.new(size: :sm, name: :test)
  end

  # @label Base (Default)
  def base
    render Flowbite::RadioButtonComponent.new(size: :base, name: :test)
  end

  def large
    render Flowbite::RadioButtonComponent.new(size: :lg, name: :test)
  end

  # @!endgroup

  # @!group Colors

  def default
    render Flowbite::RadioButtonComponent.new(checked: true, color: :default, name: :test)
  end

  def blue
    render Flowbite::RadioButtonComponent.new(checked: true, color: :blue, name: :test)
  end

  def red
    render Flowbite::RadioButtonComponent.new(checked: true, color: :red, name: :test)
  end

  def green
    render Flowbite::RadioButtonComponent.new(checked: true, color: :green, name: :test)
  end

  def yellow
    render Flowbite::RadioButtonComponent.new(checked: true, color: :yellow, name: :test)
  end

  def indigo
    render Flowbite::RadioButtonComponent.new(checked: true, color: :indigo, name: :test)
  end

  def purple
    render Flowbite::RadioButtonComponent.new(checked: true, color: :purple, name: :test)
  end

  def pink
    render Flowbite::RadioButtonComponent.new(checked: true, color: :pink, name: :test)
  end

  # @!group
end
