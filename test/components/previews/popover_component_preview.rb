# frozen_string_literal: true

# @component FoxTail::PopoverComponent
# @logical_path components
class PopoverComponentPreview < ViewComponent::Preview

  # @param placement select { choices: [top,left,bottom,right] } "Where to place the popover"
  # @param arrow toggle "Show the arrow"
  # @param header toggle "Show the popover title"
  # @param trigger_type select { choices: [hover,click] } "How to trigger the popover"
  # @param delay number "The delay used when the trigger type is 'hover'"
  def playground(placement: :top, arrow: true, header: true, trigger_type: :hover, delay: 300)
    render_with_template locals: {
      placement: placement,
      arrow: arrow,
      header: header,
      trigger_type: trigger_type,
      delay: delay,
    }
  end

  # @!group Position

  def right
    render_with_template template: "popover_component_preview/placement", locals: { placement: :right }
  end

  def bottom
    render_with_template template: "popover_component_preview/placement", locals: { placement: :bottom }
  end

  def left
    render_with_template template: "popover_component_preview/placement", locals: { placement: :left }
  end

  # @label Top (Default)
  def top
    render_with_template template: "popover_component_preview/placement", locals: { placement: :top }
  end

  # @!endgroup


  # @!group Trigger Type

  # @label On Click
  def trigger_with_click
    render_with_template template: "popover_component_preview/trigger_type", locals: { trigger_type: :click }
  end

  # @label On Hover
  def trigger_with_hover
    render_with_template template: "popover_component_preview/trigger_type", locals: { trigger_type: :hover }
  end

  # @!endgroup
end
