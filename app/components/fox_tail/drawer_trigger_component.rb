# frozen_string_literal: true

class FoxTail::DrawerTriggerComponent < FoxTail::TriggerBaseComponent
  has_option :open, default: false, type: :boolean

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self),
                                         theme.apply("root/#{open? ? :open : :close}", self),
                                         html_class
  end

  def stimulus_controller_options
    super.merge open_classes: theme.apply("root/open", self),
                closed_classes: theme.apply("root/closed", self)
  end

  class StimulusController < FoxTail::StimulusController
    def drawer_identifier
      FoxTail::DrawerComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      attributes = super options
      attributes[:data][outlet_key(drawer_identifier)] = options[:selector]
      attributes[:data][classes_key(:open)] = options[:open_classes]
      attributes[:data][classes_key(:closed)] = options[:closed_classes]
      attributes[:data][:action] = action options.fetch(:action, :toggle), event: options.fetch(:trigger_type, :click)
      attributes
    end
  end
end
