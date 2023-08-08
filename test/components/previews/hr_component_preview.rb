# frozen_string_literal: true

# @component Flowbite::HrComponent
# @logical_path typography
class HrComponentPreview < ViewComponent::Preview

  # @param trimmed toggle "Shorten the horizontal line"
  # @param shape select { choices: [none,circle,square] } "Display a shape and not a line"
  # @param size select { choices: [xs,sm,base,lg,xl] } "Size of the shape or line if not a shape"
  # @param content "Display with text"
  def playground(trimmed: false, shape: :none, size: :base, content: nil)
    render(Flowbite::HrComponent.new(trimmed: trimmed, size: size, shape: shape)) do |c|
      content if content.present?
    end
  end

  def default
    render(Flowbite::HrComponent.new)
  end

  def trimmed
    render(Flowbite::HrComponent.new(trimmed: true))
  end

  # @!group With Content

  def with_text
    render(Flowbite::HrComponent.new(trimmed: true, class: "font-light text-gray-900 dark:text-white").with_content("or"))
  end

  def with_icon
    render_with_template
  end

  # @!endgroup

  # @!group Shape

  def circle
    render(Flowbite::HrComponent.new(shape: :circle))
  end

  def square
    render(Flowbite::HrComponent.new(shape: :square))
  end

  # @!endgroup
end
