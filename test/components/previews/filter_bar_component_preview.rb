# frozen_string_literal: true

# @component FoxTail::FilterBarComponent
# @logical_path navigation
class FilterBarComponentPreview < ViewComponent::Preview
  # @param submit_type select {choices: [icon,button]}
  # @param filter_toggle_type select {choices: [icon,button]}
  def playground(submit_type: :icon, filter_toggle_type: :icon)
    render_with_template locals: { submit_type: submit_type, filter_toggle_type: filter_toggle_type }
  end
end
