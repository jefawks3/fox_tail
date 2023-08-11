# frozen_string_literal: true

class Flowbite::CollapsibleTriggerComponent < Flowbite::TriggerBaseComponent
  has_option :open, default: false, type: :boolean

  def trigger_type
    options[:trigger_type] ||= :click
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.classname("root.base"),
                                         open? && theme.classname("root.expanded"),
                                         !open? && theme.classname("root.collapsed"),
                                         html_class
  end

  def stimulus_controller_options
    super.merge open: open?,
                collapsed_classes: theme.classname("root.collapsed"),
                expanded_classes: theme.classname("root.expanded")
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    TRIGGER_TYPES = {
      click: {
        toggle: :click
      }
    }.freeze

    def collapsible_identifier
      Flowbite::CollapsibleComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      trigger_type = TRIGGER_TYPES[options[:trigger_type]&.to_sym]
      attributes = super options
      attributes[:data][classes_key(:collapsed)] = options[:collapsed_classes]
      attributes[:data][classes_key(:expanded)] = options[:expanded_classes]
      attributes[:data][outlet_key(collapsible_identifier)] = options[:selector]
      attributes[:data][:action] = build_actions(trigger_type)
      attributes[:aria] = { expanded: options[:opened], controls: extract_controls(options[:collapsible_selector]) }
      attributes
    end

    private

    def extract_controls(selector)
      selector = selector&.to_s
      selector[1..] if selector.present? && selector.start_with?("#") && !selector.match?(/\s/)
    end
  end
end
