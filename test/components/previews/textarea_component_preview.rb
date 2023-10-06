# frozen_string_literal: true

# @logical_path forms
# @component FoxTail::TextareaComponent
class TextareaComponentPreview < ViewComponent::Preview

  # @param size select {choices: [sm,base,lg]}
  # @param state select {choices: [default,valid,invalid]}
  # @param readonly toggle
  # @param disabled toggle
  # @param autoresize toggle
  def playground(size: :base, state: :default, readonly: false, disabled: false, autoresize: false)
    render FoxTail::TextareaComponent.new(
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
    render FoxTail::TextareaComponent.new(readonly: false, placeholder: "Some content...").with_content("Test content")
  end

  def readonly
    render FoxTail::TextareaComponent.new(readonly: true, placeholder: "Some content...").with_content("Test content")
  end

  # @!endgroup

  # @!group Disabled

  def active
    render FoxTail::TextareaComponent.new(disabled: false, placeholder: "Some content...").with_content("Test content")
  end

  def disabled
    render FoxTail::TextareaComponent.new(disabled: true, placeholder: "Some content...").with_content("Test content")
  end

  # @!endgroup

  # @!group Sizes

  def small
    render FoxTail::TextareaComponent.new(size: :sm, placeholder: "Some content...")
  end

  # @label Base (Default)
  def base
    render FoxTail::TextareaComponent.new(size: :base, placeholder: "Some content...")
  end

  def large
    render FoxTail::TextareaComponent.new(size: :lg, placeholder: "Some content...")
  end

  # @!endgroup

  # @!group States

  def default
    render FoxTail::TextareaComponent.new(state: :default, placeholder: "Some content...")
  end

  def valid
    render FoxTail::TextareaComponent.new(state: :valid, placeholder: "Some content...")
  end

  def invalid
    render FoxTail::TextareaComponent.new(state: :invalid, placeholder: "Some content...")
  end

  # @!endgroup

  # @!group Auto Resize

  def static
    render FoxTail::TextareaComponent.new(autoresize: false, placeholder: "Some content...")
  end

  def autoresize
    render FoxTail::TextareaComponent.new(autoresize: true, rows: 1, placeholder: "Some content...")
  end

  # @!endgroup
end
