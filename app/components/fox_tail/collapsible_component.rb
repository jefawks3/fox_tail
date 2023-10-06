# frozen_string_literal: true

class FoxTail::CollapsibleComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::HasStimulusController

  attr_reader :id

  renders_one :trigger, lambda { |attributes = {}|
    FoxTail::CollapsibleTriggerComponent.new trigger_id, "##{id}", attributes.merge(open: open?)
  }

  has_option :open, default: false, type: :boolean
  has_option :trigger_id

  def initialize(id, html_attributes = {})
    super(html_attributes)
    @id = id
  end

  def trigger_id
    options[:trigger_id] ||= :"#{id}_trigger"
  end

  def before_render
    super

    html_attributes[:id] = id
    html_attributes[:class] = classnames theme.apply(:root, self),
                                         !open? && theme.apply("root/collapsed", self),
                                         html_class
  end

  def call
    capture do
      concat trigger if trigger?
      concat content_tag(:div, content, html_attributes)
    end
  end

  def stimulus_controller_options
    {
      open: open?,
      hidden_classes: theme.apply("root/collapsed", self)
    }
  end

  class StimulusController < FoxTail::StimulusController
    def attributes(options = {})
      attributes = super options
      attributes[:data][value_key(:collapsed)] = !options[:open]
      attributes[:data][classes_key(:hidden)] = options[:hidden_classes]
      attributes
    end
  end
end
