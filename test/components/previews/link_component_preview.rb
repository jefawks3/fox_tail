# frozen_string_literal: true

class LinkComponentPreview < ViewComponent::Preview

  # @param color "The theme color"
  # @param disabled toggle "Disable the link"
  def playground(color: :default, disabled: false)
    render(Flowbite::LinkComponent.new("#", color: color, disabled: disabled).with_content("Link"))
  end

  # @!group Theme

  def neutral
    render(Flowbite::LinkComponent.new("#", color: :neutral).with_content("Link"))
  end

  def dark
    render(Flowbite::LinkComponent.new("#", color: :dark).with_content("Link"))
  end

  def light
    render(Flowbite::LinkComponent.new("#", color: :light).with_content("Link"))
  end

  # @label Blue (Default)
  def blue
    render(Flowbite::LinkComponent.new("#", color: :blue).with_content("Link"))
  end

  def red
    render(Flowbite::LinkComponent.new("#", color: :red).with_content("Link"))
  end

  def green
    render(Flowbite::LinkComponent.new("#", color: :green).with_content("Link"))
  end

  def yellow
    render(Flowbite::LinkComponent.new("#", color: :yellow).with_content("Link"))
  end

  def indigo
    render(Flowbite::LinkComponent.new("#", color: :indigo).with_content("Link"))
  end

  def purple
    render(Flowbite::LinkComponent.new("#", color: :purple).with_content("Link"))
  end

  def pink
    render(Flowbite::LinkComponent.new("#", color: :pink).with_content("Link"))
  end

  def info
    render(Flowbite::LinkComponent.new("#", color: :info).with_content("Link"))
  end

  def success
    render(Flowbite::LinkComponent.new("#", color: :success).with_content("Link"))
  end

  def warning
    render(Flowbite::LinkComponent.new("#", color: :warning).with_content("Link"))
  end

  def error
    render(Flowbite::LinkComponent.new("#", color: :error).with_content("Link"))
  end

  # @!endgroup

  # @!group Styles

  def default
    render(Flowbite::LinkComponent.new("#").with_content("Link"))
  end

  def disabled
    render(Flowbite::LinkComponent.new("#", disabled: true).with_content("Link"))
  end

  # @!endgroup

  def controlled
    render(Flowbite::LinkComponent.new("#", controlled: true, onclick: "this.setAttribute('data-flowbite--clickable-state-value', 'disable')").with_content("Link"))
  end
end
