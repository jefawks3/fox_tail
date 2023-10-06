# frozen_string_literal: true

# @logical_path forms
# @component FoxTail::CheckboxComponent
class CheckboxComponentPreview < ViewComponent::Preview

  # @param size select {choices: [sm,base,lg]}
  # @param color select {choices: [default,blue,red,green,yellow,indigo,purple,pink]}
  # @param checked toggle
  # @param disabled toggle
  def playground(size: :base, color: :default, checked: true, disabled: false)
    render FoxTail::CheckboxComponent.new(size: size, color: color, checked: checked, disabled: disabled)
  end

  # @!group Checked

  def unchecked
    render FoxTail::CheckboxComponent.new(checked: false)
  end

  def checked
    render FoxTail::CheckboxComponent.new(checked: true)
  end

  # @!endgroup

  # @!group Disabled

  def active
    render FoxTail::CheckboxComponent.new(disabled: false)
  end

  def disabled
    render FoxTail::CheckboxComponent.new(disabled: true)
  end

  # @!endgroup

  # @!group Sizes

  def small
    render FoxTail::CheckboxComponent.new(size: :sm)
  end

  # @label Base (Default)
  def base
    render FoxTail::CheckboxComponent.new(size: :base)
  end

  def large
    render FoxTail::CheckboxComponent.new(size: :lg)
  end

  # @!endgroup

  # @!group Colors

  def default
    render FoxTail::CheckboxComponent.new(color: :default, checked: true)
  end

  def blue
    render FoxTail::CheckboxComponent.new(color: :blue, checked: true)
  end

  def red
    render FoxTail::CheckboxComponent.new(color: :red, checked: true)
  end

  def green
    render FoxTail::CheckboxComponent.new(color: :green, checked: true)
  end

  def yellow
    render FoxTail::CheckboxComponent.new(color: :yellow, checked: true)
  end

  def indigo
    render FoxTail::CheckboxComponent.new(color: :indigo, checked: true)
  end

  def purple
    render FoxTail::CheckboxComponent.new(color: :purple, checked: true)
  end

  def pink
    render FoxTail::CheckboxComponent.new(color: :pink, checked: true)
  end

  # @!endgroup
end
