# frozen_string_literal: true

# @logical_path forms
# @component FoxTail::DropzoneComponent
class DropzoneComponentPreview < ViewComponent::Preview
  # @param icon
  # @param title
  # @param helper_text
  def playground(
    icon: nil,
    title: nil,
    helper_text: "SVG, PNG, JPG or GIF (MAX. 800x400px)"
  )
    render FoxTail::DropzoneComponent.new do |c|
      c.with_icon icon, variant: :outline if icon.present?
      c.with_title title.html_safe if title.present?
      c.with_helper_text helper_text if helper_text.present?
    end
  end

  def default
    render FoxTail::DropzoneComponent.new
  end

  def custom_icon
    render FoxTail::DropzoneComponent.new do |c|
      c.with_icon "document-arrow-up"
    end
  end

  def custom_title
    render FoxTail::DropzoneComponent.new do |c|
      c.with_title "Click or drag files to upload."
    end
  end

  def with_helper_text
    render FoxTail::DropzoneComponent.new do |c|
      c.with_helper_text "SVG, PNG, JPG or GIF (MAX. 800x400px)"
    end
  end
end
