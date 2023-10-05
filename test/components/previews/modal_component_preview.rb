# frozen_string_literal: true

# @logical_path components
# @component Flowbite::ModalComponent
class ModalComponentPreview < ViewComponent::Preview
  # @!group Style
  def popup
    render_with_template
  end

  def dialog
    render_with_template
  end

  # @!endgroup

  # @!group Behavior

  def closable
    render_with_template
  end

  def static
    render_with_template
  end

  def not_closable
    render_with_template
  end

  # @!endgroup

  def multiple
    render_with_template
  end

  # @!group Backdrop

  def with_backdrop
    render_with_template
  end

  def without_backdrop
    render_with_template
  end

  # @!endgroup

  # @!group Size

  def small
    render_with_template template: "modal_component_preview/size_small"
  end

  def base
    render_with_template template: "modal_component_preview/size_base"
  end

  def large
    render_with_template template: "modal_component_preview/size_large"
  end

  def extra_large
    render_with_template template: "modal_component_preview/size_extra_large"
  end

  # @!endgroup

  # @!group Placement

  def top_left
    render_with_template template: "modal_component_preview/placement_top_left"
  end

  def top_center
    render_with_template template: "modal_component_preview/placement_top_center"
  end

  def top_right
    render_with_template template: "modal_component_preview/placement_top_right"
  end

  def center_left
    render_with_template template: "modal_component_preview/placement_center_left"
  end

  def center
    render_with_template template: "modal_component_preview/placement_center"
  end

  def center_right
    render_with_template template: "modal_component_preview/placement_center_right"
  end

  def bottom_left
    render_with_template template: "modal_component_preview/placement_bottom_left"
  end

  def bottom_center
    render_with_template template: "modal_component_preview/placement_bottom_center"
  end

  def bottom_right
    render_with_template template: "modal_component_preview/placement_bottom_right"
  end

  # @!endgroup
end
