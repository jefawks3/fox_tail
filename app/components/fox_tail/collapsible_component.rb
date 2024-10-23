# frozen_string_literal: true

class FoxTail::CollapsibleComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable
  include FoxTail::Concerns::HasStimulusController

  renders_one :trigger, lambda { |attributes = {}|
    FoxTail::CollapsibleTriggerComponent.new "##{id}", attributes.merge(open: open?, id: trigger_id)
  }

  has_option :open, default: false, type: :boolean
  has_option :trigger_id

  def initialize(id_or_attributes = {}, html_attributes = {})
    if id_or_attributes.is_a? Hash
      html_attributes = id_or_attributes
    else
      __id_argument_deprecated_warning
      html_attributes[:id] = id_or_attributes
    end

    super(html_attributes)
  end

  def trigger_id
    options[:trigger_id] ||= :"#{id}_trigger"
  end

  def before_render
    super

    generate_unique_id
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
      attributes = super
      attributes[:data][value_key(:collapsed)] = !options[:open]
      attributes[:data][classes_key(:hidden)] = options[:hidden_classes]
      attributes
    end
  end
end
