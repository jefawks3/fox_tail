# frozen_string_literal: true

# @component FoxTail::IconButtonComponent
# @logical_path components
class IconButtonComponentPreview < ViewComponent::Preview
  # @param icon "The Heroicon to use"
  # @param color "The theme color to use"
  # @param variant select { choices: [solid,outline] } "The button style"
  # @param size select { choices: [xs,sm,base,lg,xl] } "The size of the button"
  # @param pill toggle "Display the button as a circle"
  # @param content "The hidden text for screen readers"
  def playground(icon: "arrow-right", color: :default, variant: :solid, size: :base, pill: false, content: nil)
    render(FoxTail::IconButtonComponent.new(icon, color: color, variant: variant, size: size, pill: pill)) do
      content
    end
  end

  # @!group Sizes

  # @label Extra Small
  def xs
    render(FoxTail::IconButtonComponent.new("arrow-right", size: :xs))
  end

  # @label Small
  def sm
    render(FoxTail::IconButtonComponent.new("arrow-right", size: :sm))
  end

  # @label Base (Default)
  def base
    render(FoxTail::IconButtonComponent.new("arrow-right", size: :base))
  end

  # @label Large
  def lg
    render(FoxTail::IconButtonComponent.new("arrow-right", size: :lg))
  end

  # @label Extra Large
  def xl
    render(FoxTail::IconButtonComponent.new("arrow-right", size: :xl))
  end

  # @!endgroup

  # @!group Styles

  def default
    render(FoxTail::IconButtonComponent.new("arrow-right"))
  end

  def rounded
    render(FoxTail::IconButtonComponent.new("arrow-right", pill: true))
  end

  def outline
    render(FoxTail::IconButtonComponent.new("arrow-right", variant: :outline))
  end

  def disabled
    render(FoxTail::IconButtonComponent.new("arrow-right", disabled: true))
  end

  # @!endgroup

  # @!group FAB

  # @label Circle
  def fab_circle
    render(FoxTail::IconButtonComponent.new("plus", size: :fab, pill: true))
  end

  # @label Square
  def fab_square
    render(FoxTail::IconButtonComponent.new("plus", size: :fab))
  end

  # @!endgroup

  def controlled
    render(FoxTail::IconButtonComponent.new("arrow-right", controlled: true, onclick: "this.setAttribute('data-fox_tail--clickable-state-value', 'disable')"))
  end
end
