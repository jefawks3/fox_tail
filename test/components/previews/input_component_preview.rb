# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::InputComponent
class InputComponentPreview < ViewComponent::Preview

  # @param size select {choices: [sm,base,lg]}
  # @param state select {choices: [default,valid,invalid]}
  # @param readonly toggle
  # @param disabled toggle
  # @param left_icon
  # @param right_icon
  def playground(readonly: false, disabled: false, size: :base, state: :default, left_icon: nil, right_icon: nil)
    render Flowbite::InputComponent.new(
      size: size,
      state: state,
      disabled: disabled,
      readonly: readonly,
      placeholder: "Placeholder"
    ) do |c|
      c.with_left_icon left_icon if left_icon.present?
      c.with_right_icon right_icon if right_icon.present?
    end
  end

  # @!group Types

  def text
    render Flowbite::InputComponent.new(type: :text, placeholder: "Enter text")
  end

  def telephone
    render Flowbite::InputComponent.new(type: :tel, placeholder: "123-456-7890")
  end

  def email
    render Flowbite::InputComponent.new(type: :email, placeholder: "username@domain.com")
  end

  def url
    render Flowbite::InputComponent.new(type: :url, placeholder: "https://example.com")
  end

  def number
    render Flowbite::InputComponent.new(type: :number, placeholder: "0")
  end

  def password
    render Flowbite::InputComponent.new(type: :password, placeholder: "*****")
  end

  # @!endgroup


  # @!group Readonly

  def editable
    render Flowbite::InputComponent.new(readonly: false, value: "Test content")
  end

  def readonly
    render Flowbite::InputComponent.new(readonly: true, value: "Test content")
  end

  # @!endgroup

  # @!group Disabled

  def active
    render Flowbite::InputComponent.new(disabled: false, placeholder: "Placeholder", value: "Test content")
  end

  def disabled
    render Flowbite::InputComponent.new(disabled: true, value: "Test content")
  end

  # @!endgroup

  # @!group Sizes

  def small
    render Flowbite::InputComponent.new(size: :sm, placeholder: "Placeholder")
  end

  # @label Base (Default)
  def base
    render Flowbite::InputComponent.new(size: :base, placeholder: "Placeholder")
  end

  def large
    render Flowbite::InputComponent.new(size: :lg, placeholder: "Placeholder")
  end

  # @!endgroup

  # @!group States

  def default
    render Flowbite::InputComponent.new(state: :default, placeholder: "Placeholder")
  end

  def valid
    render Flowbite::InputComponent.new(state: :valid, placeholder: "Placeholder")
  end

  def invalid
    render Flowbite::InputComponent.new(state: :invalid, placeholder: "Placeholder")
  end

  # @!endgroup

  # @!group Visuals

  def with_left_icon
    render Flowbite::InputComponent.new(placeholder: "Placeholder") do |c|
      c.with_left_icon "envelope"
    end
  end

  def with_right_icon
    render Flowbite::InputComponent.new(placeholder: "Placeholder") do |c|
      c.with_right_icon "envelope"
    end
  end

  def with_both_icons
    render Flowbite::InputComponent.new(placeholder: "Placeholder") do |c|
      c.with_left_icon "envelope"
      c.with_right_icon "envelope"
    end
  end

  # @!endgroup

  # @!group Name & ID Parameters

  def with_name
    render Flowbite::InputComponent.new(name: :first_name)
  end

  def with_method_name
    render Flowbite::InputComponent.new(method_name: :first_name)
  end

  def with_object_name
    render Flowbite::InputComponent.new(object_name: :user, method_name: :first_name)
  end

  def with_object_name_and_multiple
    render Flowbite::InputComponent.new(object_name: :user, method_name: :first_name, value_array: true)
  end

  def with_object_name_multiple_and_index
    render Flowbite::InputComponent.new(
      object_name: :user,
      method_name: :first_name,
      value_array: true,
      object_index: 1
    )
  end

  # @!endgroup

  # @!group Placeholder

  def string_placeholder
    render Flowbite::InputComponent.new(placeholder: "Enter first name")
  end

  def translation_placeholder
    render Flowbite::InputComponent.new(object_name: :user, method_name: :first_name, object: User.new, placeholder: true)
  end

  def missing_translation_placeholder
    render Flowbite::InputComponent.new(object_name: :user, method_name: :agree_to_terms, object: User.new, placeholder: true)
  end

  # @!endgroup
end
