# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::FileInputComponent
class FileInputComponentPreview < ViewComponent::Preview

  # @param size select {choices: [sm,base,lg]}
  # @param state select {choices: [default,valid,invalid]}
  # @param disabled toggle
  # @param multiple toggle
  def playground(size: :base, state: :default, disabled: false, multiple: false)
    render Flowbite::FileInputComponent.new(size: size, state: state, disabled: disabled, multiple: multiple)
  end

  # @!group Disabled

  def active
    render Flowbite::FileInputComponent.new(disabled: false)
  end

  def disabled
    render Flowbite::FileInputComponent.new(disabled: true)
  end

  # @!endgroup

  # @!group Sizes

  def small
    render Flowbite::FileInputComponent.new(size: :sm)
  end

  # @label Base (Default)
  def base
    render Flowbite::FileInputComponent.new(size: :base)
  end

  def large
    render Flowbite::FileInputComponent.new(size: :lg)
  end

  # @!endgroup

  # @!group Multiple

  def single
    render Flowbite::FileInputComponent.new(multiple: false)
  end

  def multiple
    render Flowbite::FileInputComponent.new(multiple: true)
  end

  # @!endgroup

  # @!group States

  def default
    render Flowbite::FileInputComponent.new(state: :default)
  end

  def valid
    render Flowbite::FileInputComponent.new(state: :valid)
  end

  def invalid
    render Flowbite::FileInputComponent.new(state: :invalid)
  end

  # @!endgroup
end
