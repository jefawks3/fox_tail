# frozen_string_literal: true

class FoxTail::FAB::ItemComponent < FoxTail::IconButtonComponent
  include FoxTail::Concerns::Identifiable

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

    if label_style == :tooltip
      trigger_component = FoxTail::TooltipTriggerComponent.new("##{tooltip_id}", id: id, trigger_type: :hover)
      trigger_component.before_render
      html_attributes.merge! trigger_component.html_attributes
    end
  end

  def tooltip_id
    :"#{id}_tooltip"
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
    render FoxTail::TooltipComponent.new(id: tooltip_id, placement: label_placement, trigger_id: id).with_content(content)
  end
end
