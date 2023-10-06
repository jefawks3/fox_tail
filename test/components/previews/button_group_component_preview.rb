# frozen_string_literal: true

# @component FoxTail::ButtonGroupComponent
# @logical_path components
class ButtonGroupComponentPreview < ViewComponent::Preview

  # @param size select { choices: [xs,sm,base,lg,xl] } "The button group size"
  # @param pill toggle "Display the group as a pill"
  # @param button_one_text
  # @param button_one_color "The them color for button one"
  # @param button_one_variant select { choices: [solid,outline] }
  # @param button_two_text
  # @param button_two_color "The them color for button one"
  # @param button_two_variant select { choices: [solid,outline] }
  # @param button_three_text
  # @param button_three_color "The them color for button one"
  # @param button_three_variant select { choices: [solid,outline] }
  def playground(
    size: :base,
    pill: false,
    button_one_text: "One",
    button_one_color: :default,
    button_one_variant: :solid,
    button_two_text: "Two",
    button_two_color: :default,
    button_two_variant: :solid,
    button_three_text: "Three",
    button_three_color: :default,
    button_three_variant: :solid
  )
    render(FoxTail::ButtonGroupComponent.new(size: size, pill: pill)) do |c|
      c.with_button(color: button_one_color, variant: button_one_variant).with_content(button_one_text)
      c.with_button(color: button_two_color, variant: button_two_variant).with_content(button_two_text)
      c.with_button(color: button_three_color, variant: button_three_variant).with_content(button_three_text)
    end
  end

  # @!group Sizes

  # @label Extra Small
  def xs
    render(FoxTail::ButtonGroupComponent.new(size: :xs)) do |c|
      c.with_button.with_content("One")
      c.with_button.with_content("Two")
      c.with_button.with_content("Three")
    end
  end

  # @label Small
  def sm
    render(FoxTail::ButtonGroupComponent.new(size: :sm)) do |c|
      c.with_button.with_content("One")
      c.with_button.with_content("Two")
      c.with_button.with_content("Three")
    end
  end

  # @label Base (Default)
  def base
    render(FoxTail::ButtonGroupComponent.new(size: :base)) do |c|
      c.with_button.with_content("One")
      c.with_button.with_content("Two")
      c.with_button.with_content("Three")
    end
  end

  # @label Large
  def lg
    render(FoxTail::ButtonGroupComponent.new(size: :lg)) do |c|
      c.with_button.with_content("One")
      c.with_button.with_content("Two")
      c.with_button.with_content("Three")
    end
  end

  # @label Extra Large
  def xl
    render(FoxTail::ButtonGroupComponent.new(size: :xl)) do |c|
      c.with_button.with_content("One")
      c.with_button.with_content("Two")
      c.with_button.with_content("Three")
    end
  end

  # @!endgroup

  # @!group Styles

  def pill
    render(FoxTail::ButtonGroupComponent.new(pill: true)) do |c|
      c.with_button.with_content("One")
      c.with_button.with_content("Two")
      c.with_button.with_content("Three")
    end
  end

  def outline
    render(FoxTail::ButtonGroupComponent.new) do |c|
      c.with_button(variant: :outline).with_content("One")
      c.with_button(variant: :outline).with_content("Two")
      c.with_button(variant: :outline).with_content("Three")
    end
  end

  def mixed
    render(FoxTail::ButtonGroupComponent.new) do |c|
      c.with_button(variant: :outline, color: :neutral).with_content("One")
      c.with_button(variant: :solid).with_content("Two")
      c.with_button(variant: :solid, color: :red).with_content("Three")
    end
  end

  def with_icons
    render(FoxTail::ButtonGroupComponent.new) do |c|
      c.with_button do |btn|
        btn.with_left_icon "user"
        "One"
      end
      c.with_button.with_content("Two")
      c.with_button.with_content("Three")
    end
  end

  # @!endgroup
end
