# frozen_string_literal: true

class FoxTail::CollapsibleTriggerComponent < FoxTail::TriggerBaseComponent
  has_option :open, default: false, type: :boolean

  def trigger_type
    options[:trigger_type] ||= :click
  end

  def before_render
    super

    html_attributes[:class] = classnames(theme.apply(:root, self), html_class)

    trigger_controller.with_class :collapsed, theme.apply("root/collapsed", self)
    trigger_controller.with_class :expanded, theme.apply("root/expanded", self)
    trigger_controller.with_action :toggle if trigger_type == :click

    html_attributes[:aria] ||= {}
    html_attributes[:aria][:expanded] = open?
    html_attributes[:aria][:controls] = extract_controls(selector)
  end
end
