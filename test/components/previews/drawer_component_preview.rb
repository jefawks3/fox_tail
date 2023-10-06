# frozen_string_literal: true

# @logical_path components
# @component FoxTail::DrawerComponent
class DrawerComponentPreview < ViewComponent::Preview

  # @param placement select {choices: [left,top,right,bottom]}
  # @param close_icon toggle
  # @param backdrop toggle
  # @param rounded toggle
  # @param border toggle
  # @param swipeable_edge toggle
  # @param notch toggle
  def playground(
    placement: :left,
    close_icon: true,
    backdrop: true,
    swipeable_edge: false,
    rounded: false,
    border: false,
    notch: false
  )
    render_with_template locals: {
      placement: placement,
      close_icon: close_icon,
      backdrop: backdrop,
      swipeable_edge: swipeable_edge,
      rounded: rounded,
      border: border,
      notch: notch
    }
  end
end
