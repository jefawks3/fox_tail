# frozen_string_literal: true

# @logical_path forms
# @component FoxTail::LabelComponent
class LabelComponentPreview < ViewComponent::Preview
  # @param required toggle "Visually show that the field is required"
  # @param state select { choices: [normal,valid,invalid] }
  def playground(required: false, state: :normal)
    render FoxTail::LabelComponent.new(required: required, state: state).with_content("Label")
  end

  # @!group Required

  def optional
    render FoxTail::LabelComponent.new.with_content("Label")
  end

  def required
    render FoxTail::LabelComponent.new(required: true).with_content("Label")
  end

  # @!endgroup

  # @!group States

  def normal
    render FoxTail::LabelComponent.new.with_content("Label")
  end

  def valid
    render FoxTail::LabelComponent.new(state: :valid).with_content("Label")
  end

  def invalid
    render FoxTail::LabelComponent.new(state: :invalid).with_content("Label")
  end

  # @!endgroup
end
