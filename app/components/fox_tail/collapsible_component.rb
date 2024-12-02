# frozen_string_literal: true

class FoxTail::CollapsibleComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable

  renders_one :trigger, lambda { |attributes = {}|
    FoxTail::CollapsibleTriggerComponent.new("##{id}", attributes.merge(open: open?))
  }

  has_option :open, default: false, type: :boolean
  has_option :trigger_id

  stimulated_with [:fox_tail, :collapsible], as: :collapsible do |controller|
    controller.with_value :collapsed, !open?
    controller.with_class :hidden, theme.apply("root/collapsed", self)
  end

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

    html_attributes[:class] = classnames(
      theme.apply(:root, self),
      !open? && theme.apply("root/collapsed", self),
      html_class
    )
  end

  def call
    capture do
      concat trigger if trigger?
      concat content_tag(:div, content, html_attributes)
    end
  end
end
