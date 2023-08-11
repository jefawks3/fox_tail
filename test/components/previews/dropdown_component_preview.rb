# frozen_string_literal: true

# @component Flowbite::DropdownComponent
# @component Flowbite::DropdownTriggerComponent
# @logical_path components
class DropdownComponentPreview < ViewComponent::Preview

  # @param placement select { choices: [top,bottom,left,right,top-start,top-end,bottom-start,bottom-end,right-start,right-end,left-start,left-end] } "Where to place the dropdown"
  # @param offset number "Distance from the trigger"
  # @param shift number "Offset relative to the placement"
  # @param trigger_type select { choices: [click,hover] }
  # @param delay number "Delay to show/hide when trigger type is 'hover'"
  def playground(placement: "bottom", shift: 0, offset: 10, delay: 300, trigger_type: :click)
    render_with_template locals: {
      placement: placement,
      shift: shift,
      offset: offset,
      delay: delay,
      trigger_type: trigger_type
    }
  end

  # @!group Styles

  def default
    render_with_template
  end

  def with_dividers
    render_with_template
  end

  def with_header
    render_with_template
  end

  def with_custom_content
    render_with_template
  end

  # @!endgroup

  # @!group Trigger Types

  # @label Button
  def button_trigger
    render_with_template
  end

  # @label Icon Button
  def icon_button_trigger
    render_with_template
  end

  # @label Avatar
  def avatar_trigger
    render_with_template
  end

  # @!endgroup

  # @!group Trigger Events

  def on_click
    render_with_template
  end

  def on_hover
    render_with_template
  end

  # @!endgroup
end
