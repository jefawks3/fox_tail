# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::TextareaComponent
class TextareaComponentPreview < ViewComponent::Preview

  # @param size select {choices: [sm,base,lg]}
  # @param state select {choices: [default,valid,invalid]}
  # @param readonly toggle
  # @param disabled toggle
  # @param autoresize toggle
  def playground(size: :base, state: :default, readonly: false, disabled: false, autoresize: false)
    render Flowbite::TextareaComponent.new(
      size: size,
      state: state,
      readonly: readonly,
      disabled: disabled,
      autoresize: autoresize,
      placeholder: "Enter text...",
      rows: autoresize ? 1 : nil
    )
  end

  # @!group Readonly

  def editable
    render Flowbite::TextareaComponent.new(readonly: false, placeholder: "Some content...").with_content("Test content")
  end

  def readonly
    render Flowbite::TextareaComponent.new(readonly: true, placeholder: "Some content...").with_content("Test content")
  end

  # @!endgroup

  # @!group Disabled

  def active
    render Flowbite::TextareaComponent.new(disabled: false, placeholder: "Some content...").with_content("Test content")
  end

  def disabled
    render Flowbite::TextareaComponent.new(disabled: true, placeholder: "Some content...").with_content("Test content")
  end

  # @!endgroup

  # @!group Sizes

  def small
    render Flowbite::TextareaComponent.new(size: :sm, placeholder: "Some content...")
  end

  # @label Base (Default)
  def base
    render Flowbite::TextareaComponent.new(size: :base, placeholder: "Some content...")
  end

  def large
    render Flowbite::TextareaComponent.new(size: :lg, placeholder: "Some content...")
  end

  # @!endgroup

  # @!group States

  def default
    render Flowbite::TextareaComponent.new(state: :default, placeholder: "Some content...")
  end

  def valid
    render Flowbite::TextareaComponent.new(state: :valid, placeholder: "Some content...")
  end

  def invalid
    render Flowbite::TextareaComponent.new(state: :invalid, placeholder: "Some content...")
  end

  # @!endgroup

  # @!group Auto Resize

  def static
    render Flowbite::TextareaComponent.new(autoresize: false, placeholder: "Some content...")
  end

  def autoresize
    render Flowbite::TextareaComponent.new(autoresize: true, rows: 1, placeholder: "Some content...")
  end

  # @!endgroup
end
