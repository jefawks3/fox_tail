# frozen_string_literal: true

# @component Flowbite::TooltipComponent
# @logical_path components
class TooltipComponentPreview < ViewComponent::Preview

  # @param placement select { choices: [top,bottom,right,left] } "Which side to place the tooltip"
  # @param arrow toggle "Show the arrow"
  # @param variant select { choices: [dark,light] } "The tooltip theme style"
  def playground(placement: :top, arrow: true, variant: :dark)
    render_with_template locals: { placement: placement, arrow: arrow, variant: variant }
  end

  # @!group Position

  # @label Top (Default)
  def top
    render_with_template template: "tooltip_component_preview/placement", locals: { placement: :top }
  end

  def bottom
    render_with_template template: "tooltip_component_preview/placement", locals: { placement: :bottom }
  end

  def left
    render_with_template template: "tooltip_component_preview/placement", locals: { placement: :left }
  end

  def right
    render_with_template template: "tooltip_component_preview/placement", locals: { placement: :right }
  end

  # @!endgroup

  # @!group Styles

  # @label Dark (Default)
  def dark
    render_with_template template: "tooltip_component_preview/variant", locals: { variant: :dark }
  end

  def light
    render_with_template template: "tooltip_component_preview/variant", locals: { variant: :light }
  end

  # @label Disabled Arrow
  def no_arrow
    render_with_template
  end

  # @!endgroup

  # @!group Inline

  def without_inline
    render_with_template template: "tooltip_component_preview/inline", locals: { inline: false }
  end


  def inline
    render_with_template template: "tooltip_component_preview/inline", locals: { inline: true }
  end

  # @!endgroup

  # @!group Trigger Type

  # @label Click
  def click_trigger_type
    render_with_template template: "tooltip_component_preview/trigger_type", locals: { trigger_type: :click }
  end

  # @label Hover
  def hover_trigger_type
    render_with_template template: "tooltip_component_preview/trigger_type", locals: { trigger_type: :hover }
  end

  # @!endgroup
end
