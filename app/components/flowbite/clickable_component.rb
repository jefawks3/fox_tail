# frozen_string_literal: true

class Flowbite::ClickableComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController

  has_option :url
  has_option :disabled, default: false, type: :boolean
  has_option :loading, default: false, type: :boolean
  has_option :loadable, default: false, type: :boolean
  has_option :controlled, default: false, type: :boolean

  def use_stimulus?
    controlled? && self.class.use_stimulus?
  end

  def link?
    url? && ((!disabled? && !loading?) || controlled?)
  end

  def root_tag_name
    link? ? :a : :button
  end

  def before_render
    super

    html_attributes[:class] = root_classes

    if link?
      html_attributes[:href] = url
      html_attributes["aria-disabled"] = true if disabled?
    else
      html_attributes[:role] ||= :button
      html_attributes[:type] ||= :button
      html_attributes[:disabled] = true if disabled?
    end
  end

  def call(&block)
    captured_content = block ? capture(&block) : content
    content_tag root_tag_name, captured_content, html_attributes
  end

  def stimulus_controller_options
    { state: stimulus_state, active_classes: active_classes, disabled_classes: disabled_classes }
  end

  protected

  def root_classes
    classnames theme.apply(:root, self),
               theme.apply("root/#{disabled? ? :disabled : :active}", self),
               block_given? && yield,
               html_class
  end

  def active_classes
    classnames theme.apply(:root, self),
               theme.apply("root/active", self),
               block_given? && yield,
               html_class
  end

  def disabled_classes
    classnames theme.apply("root/disabled", self), block_given? && yield
  end

  private

  def stimulus_state
    if loading?
      :loading
    elsif disabled?
      :disabled
    else
      :active
    end
  end

  class << self
    def stimulus_controller_name
      :clickable
    end
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    def attributes(options = {})
      {
        data: {
          controller: identifier,
          value_key(:state) => options[:state] || :active,
          classes_key(:active) => options[:active_classes],
          classes_key(:disabled) => options[:disabled_classes]
        }
      }
    end
  end
end
