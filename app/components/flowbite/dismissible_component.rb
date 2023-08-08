# frozen_string_literal: true

class Flowbite::DismissibleComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController
  include Flowbite::Concerns::HasStimulusTriggerController

  has_option :remove, default: false, type: :boolean

  def controller_options
    {
      remove: remove?,
      dismissing_classes: theme.classname("root.dismissing"),
      dismissed_classes: theme.classname("root.dismissed")
    }
  end

  def before_render
    super

    html_attributes[:class] = html_class
    stimulus_controller.merge! html_attributes, controller_options
  end

  def call
    content_tag :button, content, html_attributes
  end

  class << self
    def stimulus_controller_name
      :dismissible
    end
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    def attributes(options = {})
      {
        data: {
          controller: identifier,
          value_key(:remove) => options[:remove],
          classes_key(:dismissing) => options[:dismissing_classes],
          classes_key(:dismissed) => options[:dismissed_classes]
        }
      }
    end
  end

  class StimulusTriggerController < Flowbite::ViewComponents::StimulusController
    def attributes(options = {})
      {
        data: {
          controller: identifier,
          outlet_key(:dismissible) => options[:dismissible_id],
          action: action("dismiss", event: options[:event])
        }
      }
    end
  end
end
