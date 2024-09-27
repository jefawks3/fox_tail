# frozen_string_literal: true

class FoxTail::TextareaComponent < FoxTail::InputBaseComponent
  has_option :autoresize, type: :boolean, default: false

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    AutoResizeStimulusController.new.merge! html_attributes if self.class.use_stimulus? && autoresize?
  end

  def call
    content_tag :textarea, object_name? ? value_from_object : content, html_attributes
  end

  class AutoResizeStimulusController < FoxTail::StimulusController
    def initialize(config: nil)
      super("fox_tail--textarea-auto-resize", config: config)
    end
  end
end
