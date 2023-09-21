# frozen_string_literal: true

# @logical_path forms
# @component Flowbite::LabelComponent
class LabelComponentPreview < ViewComponent::Preview

  # @param required toggle "Visually show that the field is required"
  # @param state select { choices: [normal,valid,invalid] }
  def playground(required: false, state: :normal)
    render Flowbite::LabelComponent.new(required: required, state: state).with_content("Label")
  end

  # @!group Required

  def optional
    render Flowbite::LabelComponent.new.with_content("Label")
  end

  def required
    render Flowbite::LabelComponent.new(required: true).with_content("Label")
  end

  # @!endgroup

  # @!group States

  def normal
    render Flowbite::LabelComponent.new.with_content("Label")
  end

  def valid
    render Flowbite::LabelComponent.new(state: :valid).with_content("Label")
  end

  def invalid
    render Flowbite::LabelComponent.new(state: :invalid).with_content("Label")
  end

  # @!endgroup
end
