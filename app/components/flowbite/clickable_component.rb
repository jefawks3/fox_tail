# frozen_string_literal: true

class Flowbite::ClickableComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusController

  has_option :url
  has_option :disabled, default: false, type: :boolean
  has_option :loading, default: false, type: :boolean
  has_option :loadable, default: false, type: :boolean
  has_option :controlled, default: false, type: :boolean

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

    if controlled?
      html_attributes[:data] ||= {}
      html_attributes[:data][:controller] = stimulus_controllers html_attributes[:controller],
                                                                 stimulus_controller_identifier

      state = if loading?
                :loading
              elsif disabled?
                :disabled
              else
                :active
              end

      html_attributes[:data][stimulus_controller.value_key(:state)] = state
      html_attributes[:data][stimulus_controller.classes_key(:active)] = active_classes
      html_attributes[:data][stimulus_controller.classes_key(:disabled)] = disabled_classes
    end
  end

  def call(&block)
    captured_content = block ? capture(&block) : content
    tag_name = link? ? :a : :button
    content_tag tag_name, captured_content, html_attributes
  end

  protected

  def root_classes
    classnames html_class
  end

  def active_classes
    classnames html_class
  end

  def disabled_classes; end

  private

  def link?
    url? && ((!disabled? && !loading?) || controlled?)
  end

  class << self
    def stimulus_controller_name
      :clickable
    end
  end
end
