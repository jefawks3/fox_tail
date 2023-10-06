# frozen_string_literal: true

# @component FoxTail::CollapsibleComponent
# @component FoxTail::CollapsibleTriggerComponent
# @logical_path components
class CollapsibleComponentPreview < ViewComponent::Preview

  # @param opened toggle "Start opened"
  def playground(opened: false)
    render_with_template template: "collapsible_component_preview/playground",
                         locals: { id: :playground_collapsible, opened: opened }
  end

  # @!group Open Start State

  def opened
    render_with_template template: "collapsible_component_preview/playground",
                         locals: { id: :opened_collapsible, opened: true }
  end

  def closed
    render_with_template template: "collapsible_component_preview/playground",
                         locals: { id: :closed_collapsible, opened: false }
  end

  # @!endgroup
end
