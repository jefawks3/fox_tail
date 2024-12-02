# frozen_string_literal: true

class FoxTail::TooltipComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable

  renders_one :trigger, lambda { |attributes = {}|
    attributes[:id] = trigger_id
    FoxTail::TooltipTriggerComponent.new "##{id}", attributes
  }

  has_option :variant, default: :default
  has_option :placement, default: :top
  has_option :arrow, default: true, type: :boolean
  has_option :offset, default: 8
  has_option :shift
  has_option :inline, default: false, type: :boolean
  has_option :trigger_id

  stimulated_with [:fox_tail, :tooltip], as: :tooltip

  def initialize(id_or_attributes = {}, html_attributes = {})
    if id_or_attributes.is_a? Hash
      html_attributes = id_or_attributes
    else
      __id_argument_deprecated_warning
      html_attributes[:id] = id_or_attributes
    end

    super(html_attributes)
  end

  def trigger_controller
    stimulated.with([:fox_tail, :tooltip_trigger])
  end

  def trigger_id
    options[:trigger_id] ||= :"#{id}_trigger"
  end

  def before_render
    super

    generate_unique_id
    html_attributes[:role] ||= :tooltip

    html_attributes[:class] = classnames(
      theme.apply(:root, self),
      theme.apply("root/hidden", self),
      html_class
    )

    tooltip_controller.with_value :placement, placement
    tooltip_controller.with_value :offset, offset
    tooltip_controller.with_value :shift, shift
    tooltip_controller.with_value :inline, inline?
    tooltip_controller.with_class :visible, theme.apply("root/visible", self)
    tooltip_controller.with_class :hidden, theme.apply("root/hidden", self)
    tooltip_controller.with_outlet trigger_controller.identifier, trigger_id
  end

  def call
    capture do
      concat trigger if trigger?
      concat render_tooltip
    end
  end

  private

  def render_tooltip
    content_tag :div, html_attributes do
      concat content
      concat render_arrow if arrow?
    end
  end

  def render_arrow
    content_tag :div, nil, class: theme.apply(:arrow, self)
  end
end
