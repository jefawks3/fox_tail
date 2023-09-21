# frozen_string_literal: true

class Flowbite::TextareaComponent < Flowbite::InputBaseComponent
  has_option :autoresize, type: :boolean, default: false

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    AutoResizeStimulusController.new.merge! html_attributes if use_stimulus? && autoresize?
  end

  def call
    content_tag :textarea, content, html_attributes
  end

  class AutoResizeStimulusController < Flowbite::ViewComponents::StimulusController
    def initialize(config: nil)
      super("flowbite--textarea-auto-resize", config: config)
    end
  end
end
