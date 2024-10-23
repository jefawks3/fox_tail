# frozen_string_literal: true

class FoxTail::PasswordInputTriggerComponent < FoxTail::TriggerBaseComponent
  def before_render
    super

    html_attributes[:class] = classnames theme.apply("root/hidden", self), html_class
    html_attributes[:aria] ||= {}
    html_attributes[:aria][:controls] = selector.gsub(/^[#|.]/, "")
    html_attributes[:aria][:expanded] = false
  end

  def stimulus_controller_options
    super.merge hidden_classes: theme.apply("root/hidden", self),
      visible_classes: theme.apply("root/visible", self)
  end

  class StimulusController < FoxTail::StimulusController
    def password_input_identifier
      FoxTail::PasswordInputComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      attributes = super
      attributes[:data][outlet_key(password_input_identifier)] = options[:selector]
      attributes[:data][classes_key(:hidden)] = options[:hidden_classes]
      attributes[:data][classes_key(:visible)] = options[:visible_classes]
      attributes[:data][:action] = action(:toggle)
      attributes
    end
  end
end
