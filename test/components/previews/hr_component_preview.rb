# frozen_string_literal: true

# @component FoxTail::HrComponent
# @logical_path typography
class HrComponentPreview < ViewComponent::Preview
  # @param trimmed toggle "Shorten the horizontal line"
  # @param shape select { choices: [none,circle,square] } "Display a shape and not a line"
  # @param size select { choices: [xs,sm,base,lg,xl] } "Size of the shape or line if not a shape"
  # @param content "Display with text"
  def playground(trimmed: false, shape: :none, size: :base, content: nil)
    render(FoxTail::HrComponent.new(trimmed: trimmed, size: size, shape: shape)) do |c|
      content.presence
    end
  end

  def default
    render(FoxTail::HrComponent.new)
  end

  def trimmed
    render(FoxTail::HrComponent.new(trimmed: true))
  end

  # @!group With Content

  def with_text
    render(FoxTail::HrComponent.new(trimmed: true, class: "font-light text-gray-900 dark:text-white").with_content("or"))
  end

  def with_icon
    render_with_template
  end

  # @!endgroup

  # @!group Shape

  def circle
    render(FoxTail::HrComponent.new(shape: :circle))
  end

  def square
    render(FoxTail::HrComponent.new(shape: :square))
  end

  # @!endgroup
end
