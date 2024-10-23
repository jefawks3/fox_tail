# frozen_string_literal: true

# @component FoxTail::LinkComponent
# @logical_path typography
class LinkComponentPreview < ViewComponent::Preview
  # @param color "The theme color"
  # @param disabled toggle "Disable the link"
  def playground(color: :default, disabled: false)
    render(FoxTail::LinkComponent.new("#", color: color, disabled: disabled).with_content("Link"))
  end

  # @!group Theme

  def neutral
    render(FoxTail::LinkComponent.new("#", color: :neutral).with_content("Link"))
  end

  def dark
    render(FoxTail::LinkComponent.new("#", color: :dark).with_content("Link"))
  end

  def light
    render(FoxTail::LinkComponent.new("#", color: :light).with_content("Link"))
  end

  # @label Blue (Default)
  def blue
    render(FoxTail::LinkComponent.new("#", color: :blue).with_content("Link"))
  end

  def red
    render(FoxTail::LinkComponent.new("#", color: :red).with_content("Link"))
  end

  def green
    render(FoxTail::LinkComponent.new("#", color: :green).with_content("Link"))
  end

  def yellow
    render(FoxTail::LinkComponent.new("#", color: :yellow).with_content("Link"))
  end

  def indigo
    render(FoxTail::LinkComponent.new("#", color: :indigo).with_content("Link"))
  end

  def purple
    render(FoxTail::LinkComponent.new("#", color: :purple).with_content("Link"))
  end

  def pink
    render(FoxTail::LinkComponent.new("#", color: :pink).with_content("Link"))
  end

  def info
    render(FoxTail::LinkComponent.new("#", color: :info).with_content("Link"))
  end

  def success
    render(FoxTail::LinkComponent.new("#", color: :success).with_content("Link"))
  end

  def warning
    render(FoxTail::LinkComponent.new("#", color: :warning).with_content("Link"))
  end

  def error
    render(FoxTail::LinkComponent.new("#", color: :danger).with_content("Link"))
  end

  # @!endgroup

  # @!group Styles

  def default
    render(FoxTail::LinkComponent.new("#").with_content("Link"))
  end

  def disabled
    render(FoxTail::LinkComponent.new("#", disabled: true).with_content("Link"))
  end

  # @!endgroup

  def controlled
    render(FoxTail::LinkComponent.new("#", controlled: true, onclick: "this.setAttribute('data-fox_tail--clickable-state-value', 'disable')").with_content("Link"))
  end
end
