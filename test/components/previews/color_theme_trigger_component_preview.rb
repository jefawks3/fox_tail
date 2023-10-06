# frozen_string_literal: true

# @label Color Theme
# @component FoxTail::ColorThemeTrigger
# @logical_path components
class ColorThemeTriggerComponentPreview < ViewComponent::Preview

  def toggle
    render_with_template
  end
end
