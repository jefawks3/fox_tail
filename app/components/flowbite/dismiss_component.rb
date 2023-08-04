# frozen_string_literal: true

class Flowbite::DismissComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusAndFlowbiteController

  attr_reader :target_id

  has_option :duration
  has_option :timing

  def initialize(target_id, html_attributes = {})
    @target_id = target_id
    super(html_attributes)
  end

  def controller_options
    {
      target_id: target_id,
      duration: duration,
      timing: timing,
      transition_classes: theme.classname("root.transition")
    }
  end

  def before_render
    super

    html_attributes[:class] = html_class
    controller.merge! html_attributes, controller_options
  end

  def call
    content_tag :button, content, html_attributes
  end

  class << self
    def dismiss_options_keys
      %i[target_id transiation_classes duration timing]
    end
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    def attributes(options = {})
      {
        data: {
          controller: identifier,
          value_key(:target) => options[:target_id],
          classes_key(:transition) => options[:transition_classes],
          value_key(:duration) => options[:duration],
          value_key(:timing) => options[:timing]
        }
      }
    end
  end

  class FlowbiteController < Flowbite::ViewComponents::FlowbiteController
    def attributes(options = {})
      {
        data: {
          dismiss_target: options[:target_id],
          dismiss_transition: options[:transition_classes],
          dismiss_duration: options[:duration],
          dismiss_timing: options[:timing]
        }
      }
    end
  end
end
