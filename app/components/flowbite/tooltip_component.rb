# frozen_string_literal: true

class Flowbite::TooltipComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController

  attr_reader :id

  renders_one :trigger, lambda { |attributes = {}|
    Flowbite::TooltipTriggerComponent.new trigger_id, "##{id}", attributes
  }

  has_option :variant, default: :default
  has_option :placement, default: :top
  has_option :arrow, default: true, type: :boolean
  has_option :offset, default: 8
  has_option :shift
  has_option :inline, default: false, type: :boolean
  has_option :trigger_id

  def initialize(id, html_attributes = {})
    @id = id
    super(html_attributes)
    with_trigger_id :"#{id}_trigger" unless trigger_id?
  end

  def before_render
    super

    html_attributes[:id] = id
    html_attributes[:role] ||= :tooltip
    html_attributes[:class] = classnames theme.apply(:root, self), theme.apply("root/hidden", self), html_class
  end

  def call
    capture do
      concat trigger if trigger?
      concat render_tooltip
    end
  end

  def stimulus_controller_options
    {
      trigger_id: trigger_id,
      placement: placement,
      offset: offset,
      shift: shift,
      inline: inline?,
      visible_classes: theme.apply("root/visible", self),
      hidden_classes: theme.apply("root/hidden", self)
    }
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

  class StimulusController < Flowbite::ViewComponents::StimulusController
    def trigger_identifier
      Flowbite::TooltipTriggerComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      attributes = super options
      attributes[:data][value_key(:placement)] = options[:placement]
      attributes[:data][value_key(:offset)] = options[:offset]
      attributes[:data][value_key(:shift)] = options[:shift]
      attributes[:data][value_key(:inline)] = options[:inline]
      attributes[:data][outlet_key(trigger_identifier)] = "##{options[:trigger_id]}"
      attributes[:data][classes_key(:hidden)] = options[:hidden_classes]
      attributes[:data][classes_key(:visible)] = options[:visible_classes]
      attributes
    end
  end
end
