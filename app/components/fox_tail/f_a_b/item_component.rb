# frozen_string_literal: true

class FoxTail::FAB::ItemComponent < FoxTail::IconButtonComponent
  DEFAULT_OPTIONS = {color: :light, variant: :solid}.freeze

  has_option :placement, default: :top
  has_option :label_placement, default: :left
  has_option :label_style, default: :tooltip

  def initialize(icon_or_attributes = {}, html_attributes = {})
    if icon_or_attributes.is_a? Hash
      icon_or_attributes.reverse_merge! DEFAULT_OPTIONS
    else
      html_attributes.reverse_merge! DEFAULT_OPTIONS
    end

    super
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class

    if label_style == :tooltip && self.class.use_stimulus?
      trigger_component = FoxTail::TooltipTriggerComponent.new tag_id, "##{tooltip_id}", trigger_type: :hover
      options = trigger_component.stimulus_controller_options
      attributes = FoxTail::TooltipTriggerComponent.stimulus_controller.attributes options
      stimulus_merger.merge_attributes! html_attributes, attributes
    end
  end

  def tag_id
    html_attributes[:id] ||= :"fab_item_#{SecureRandom.hex(4)}"
  end

  def tooltip_id
    :"tooltip_#{tag_id}"
  end

  def size
    :fab
  end

  alias_method :render_button, :call
  private :render_button

  def call
    capture do
      concat render_button
      concat render_tooltip if label_style == :tooltip
    end
  end

  private

  def render_tooltip
    render FoxTail::TooltipComponent.new(tooltip_id, placement: label_placement, trigger_id: tag_id).with_content(content)
  end
end
