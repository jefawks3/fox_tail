# frozen_string_literal: true

# @logical_path forms
# @component FoxTail::HelperTextComponent
class HelperTextComponentPreview < ViewComponent::Preview

  # @param state select { choices: [normal,valid,invalid] }
  def playground(state: :normal)
    render FoxTail::HelperTextComponent.new(state: state).with_content("A message to help the user.")
  end

  # @!group States

  def normal
    render FoxTail::HelperTextComponent.new.with_content("A message to help the user.")
  end

  def valid
    render FoxTail::HelperTextComponent.new(state: :valid).with_content("A message to help the user.")
  end

  def invalid
    render FoxTail::HelperTextComponent.new(state: :invalid).with_content("A message to help the user.")
  end

  # @!endgroup

  # @!group i18n

  def translation
    render FoxTail::HelperTextComponent.new(object_name: :user, method_name: :url)
  end

  def missing_translation
    render FoxTail::HelperTextComponent.new(object_name: :user, method_name: :first_name)
  end

  # @!endgroup
end
