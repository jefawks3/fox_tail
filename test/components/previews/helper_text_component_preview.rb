# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::HelperTextComponent
class HelperTextComponentPreview < ViewComponent::Preview

  # @param state select { choices: [normal,valid,invalid] }
  def playground(state: :normal)
    render Flowbite::HelperTextComponent.new(state: state).with_content("A message to help the user.")
  end

  # @!group States

  def normal
    render Flowbite::HelperTextComponent.new.with_content("A message to help the user.")
  end

  def valid
    render Flowbite::HelperTextComponent.new(state: :valid).with_content("A message to help the user.")
  end

  def invalid
    render Flowbite::HelperTextComponent.new(state: :invalid).with_content("A message to help the user.")
  end

  # @!endgroup

  # @!group i18n

  def translation
    render Flowbite::HelperTextComponent.new(object_name: :user, method_name: :url)
  end

  def missing_translation
    render Flowbite::HelperTextComponent.new(object_name: :user, method_name: :first_name)
  end

  # @!endgroup
end
