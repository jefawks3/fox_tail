# frozen_string_literal: true

class ButtonComponentPreview < ViewComponent::Preview

  # @param color "The theme color of the button"
  # @param variant select { choices: [solid,outline] } "The theme variant of the button"
  # @param pill toggle "Display as a pill button"
  # @param loading toggle "Display the loading icon"
  # @param disabled toggle "Disable the button"
  def playground(color: :default, variant: :solid, pill: false, loading: false, disabled: false)
    render(Flowbite::ButtonComponent.new(color: color, variant: variant, pill: pill, loading: loading, disabled: disabled)) do |c|
      "Button"
    end
  end

  # @!group Theme

  # @label Neutral
  def neutral
    render(Flowbite::ButtonComponent.new(color: :neutral, variant: :solid).with_content("Button"))
  end

  # @label Dark
  def dark
    render(Flowbite::ButtonComponent.new(color: :dark, variant: :solid).with_content("Button"))
  end

  # @label Light
  def light
    render(Flowbite::ButtonComponent.new(color: :light, variant: :solid).with_content("Button"))
  end

  # @label Blue (Default)
  def blue
    render(Flowbite::ButtonComponent.new(color: :blue, variant: :solid).with_content("Button"))
  end

  # @label Red
  def red
    render(Flowbite::ButtonComponent.new(color: :red, variant: :solid).with_content("Button"))
  end

  # @label Green
  def green
    render(Flowbite::ButtonComponent.new(color: :green, variant: :solid).with_content("Button"))
  end

  # @label Yellow
  def yellow
    render(Flowbite::ButtonComponent.new(color: :yellow, variant: :solid).with_content("Button"))
  end

  # @label Indigo
  def indigo
    render(Flowbite::ButtonComponent.new(color: :indigo, variant: :solid).with_content("Button"))
  end

  # @label Purple
  def purple
    render(Flowbite::ButtonComponent.new(color: :purple, variant: :solid).with_content("Button"))
  end

  # @label Pink
  def pink
    render(Flowbite::ButtonComponent.new(color: :pink, variant: :solid).with_content("Button"))
  end

  # @label Info
  def info
    render(Flowbite::ButtonComponent.new(color: :info, variant: :solid).with_content("Button"))
  end

  # @label Success
  def success
    render(Flowbite::ButtonComponent.new(color: :success, variant: :solid).with_content("Button"))
  end

  # @label Warning
  def warning
    render(Flowbite::ButtonComponent.new(color: :warning, variant: :solid).with_content("Button"))
  end

  # @label Error
  def error
    render(Flowbite::ButtonComponent.new(color: :error, variant: :solid).with_content("Button"))
  end

  # @!endgroup

  # @!group Outline

  # @label Neutral
  def outline_neutral
    render(Flowbite::ButtonComponent.new(color: :neutral, variant: :outline).with_content("Button"))
  end

  # @label Dark
  def outline_dark
    render(Flowbite::ButtonComponent.new(color: :dark, variant: :outline).with_content("Button"))
  end

  # @label Light
  def outline_light
    render(Flowbite::ButtonComponent.new(color: :light, variant: :outline).with_content("Button"))
  end

  # @label Blue (Default)
  def outline_blue
    render(Flowbite::ButtonComponent.new(color: :blue, variant: :outline).with_content("Button"))
  end

  # @label Red
  def outline_red
    render(Flowbite::ButtonComponent.new(color: :red, variant: :outline).with_content("Button"))
  end

  # @label Green
  def outline_green
    render(Flowbite::ButtonComponent.new(color: :green, variant: :outline).with_content("Button"))
  end

  # @label Yellow
  def outline_yellow
    render(Flowbite::ButtonComponent.new(color: :yellow, variant: :outline).with_content("Button"))
  end

  # @label Indigo
  def outline_indigo
    render(Flowbite::ButtonComponent.new(color: :indigo, variant: :outline).with_content("Button"))
  end

  # @label Purple
  def outline_purple
    render(Flowbite::ButtonComponent.new(color: :purple, variant: :outline).with_content("Button"))
  end

  # @label Pink
  def outline_pink
    render(Flowbite::ButtonComponent.new(color: :pink, variant: :outline).with_content("Button"))
  end

  # @label Info
  def outline_info
    render(Flowbite::ButtonComponent.new(color: :info, variant: :outline).with_content("Button"))
  end

  # @label Success
  def outline_success
    render(Flowbite::ButtonComponent.new(color: :success, variant: :outline).with_content("Button"))
  end

  # @label Warning
  def outline_warning
    render(Flowbite::ButtonComponent.new(color: :warning, variant: :outline).with_content("Button"))
  end

  # @label Error
  def outline_error
    render(Flowbite::ButtonComponent.new(color: :error, variant: :outline).with_content("Button"))
  end

  # @!endgroup

  # @!group Pill

  # @label Neutral
  def pill_neutral
    render(Flowbite::ButtonComponent.new(color: :neutral, pill: true).with_content("Button"))
  end

  # @label Dark
  def pill_dark
    render(Flowbite::ButtonComponent.new(color: :dark, pill: true).with_content("Button"))
  end

  # @label Light
  def pill_light
    render(Flowbite::ButtonComponent.new(color: :light, pill: true).with_content("Button"))
  end

  # @label Blue (Default)
  def pill_blue
    render(Flowbite::ButtonComponent.new(color: :blue, pill: true).with_content("Button"))
  end

  # @label Red
  def pill_red
    render(Flowbite::ButtonComponent.new(color: :red, pill: true).with_content("Button"))
  end

  # @label Green
  def pill_green
    render(Flowbite::ButtonComponent.new(color: :green, pill: true).with_content("Button"))
  end

  # @label Yellow
  def pill_yellow
    render(Flowbite::ButtonComponent.new(color: :yellow, pill: true).with_content("Button"))
  end

  # @label Indigo
  def pill_indigo
    render(Flowbite::ButtonComponent.new(color: :indigo, pill: true).with_content("Button"))
  end

  # @label Purple
  def pill_purple
    render(Flowbite::ButtonComponent.new(color: :purple, pill: true).with_content("Button"))
  end

  # @label Pink
  def pill_pink
    render(Flowbite::ButtonComponent.new(color: :pink, pill: true).with_content("Button"))
  end

  # @label Info
  def pill_info
    render(Flowbite::ButtonComponent.new(color: :info, pill: true).with_content("Button"))
  end

  # @label Success
  def pill_success
    render(Flowbite::ButtonComponent.new(color: :success, pill: true).with_content("Button"))
  end

  # @label Warning
  def pill_warning
    render(Flowbite::ButtonComponent.new(color: :warning, pill: true).with_content("Button"))
  end

  # @label Error
  def pill_error
    render(Flowbite::ButtonComponent.new(color: :error, pill: true).with_content("Button"))
  end

  # @!endgroup

  # @!group Sizes

  # @label Extra Small
  def xs
    render(Flowbite::ButtonComponent.new(size: :xs).with_content("Button"))
  end

  # @label Small
  def sm
    render(Flowbite::ButtonComponent.new(size: :sm).with_content("Button"))
  end

  # @label Base (Default)
  def base
    render(Flowbite::ButtonComponent.new(size: :base).with_content("Button"))
  end

  # @label Large
  def lg
    render(Flowbite::ButtonComponent.new(size: :lg).with_content("Button"))
  end

  # @label Extra Large
  def xl
    render(Flowbite::ButtonComponent.new(size: :xl).with_content("Button"))
  end

  # @!endgroup

  # @!group Icons

  def with_left_icon
    render(Flowbite::ButtonComponent.new(size: :xl)) do |c|
      c.with_left_icon "shopping-cart"
      "Button"
    end
  end

  def with_right_icon
    render(Flowbite::ButtonComponent.new(size: :xl)) do |c|
      c.with_right_icon "arrow-right"
      "Button"
    end
  end

  # @!endgroup

  # @!group States

  def disabled
    render(Flowbite::ButtonComponent.new(disabled: true).with_content("Button"))
  end

  def loading
    render(Flowbite::ButtonComponent.new(loading: true).with_content("Loading ..."))
  end

  # @!endgroup

  # @!group Controlled

  # @label Basic
  def controlled
    render(Flowbite::ButtonComponent.new(controlled: true, onclick: "this.setAttribute('data-flowbite--clickable-state-value', 'disable')")) do |c|
      c.with_right_icon "arrow-right"
      "Upload"
    end
  end

  def loadable
    render(Flowbite::ButtonComponent.new(controlled: true, loadable: true, onclick: "this.setAttribute('data-flowbite--clickable-state-value', 'loading')")) do |c|
      c.with_loading_label.with_content "Uploading..."
      c.with_left_icon "photo"
      c.with_right_icon "arrow-up-tray"
      "Upload"
    end
  end

  # @!endgroup
end
