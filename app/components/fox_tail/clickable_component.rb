# frozen_string_literal: true

class FoxTail::ClickableComponent < FoxTail::BaseComponent
  has_option :url
  has_option :disabled, default: false, type: :boolean
  has_option :loading, default: false, type: :boolean
  has_option :loadable, default: false, type: :boolean
  has_option :controlled, default: false, type: :boolean
  has_option :form_controlled

  stimulated_with [:fox_tail, :form], as: :form, register: false

  stimulated_with [:fox_tail, :clickable], as: :clickable, if: :controlled? do |controller|
    controller.register_controller
    controller.with_value :state, stimulus_state
    controller.with_class :active, active_classes
    controller.with_class :disabled, disabled_classes

    if form_controlled == :loading && loadable?
      controller.with_action :loading, on: form_controller.event(:submit)
      controller.with_action :activate, on: form_controller.event(:finished)
    elsif form_controlled == :disable
      controller.with_action :disable, on: form_controller.event(:submit)
      controller.with_action :activate, on: form_controller.event(:finished)
    end
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

    if root_tag_name == :a
      html_attributes[:href] = url
      html_attributes["aria-disabled"] = true if disabled?
    elsif root_tag_name == :button
      html_attributes[:role] ||= :button
      html_attributes[:type] ||= :button
      html_attributes[:disabled] = true if disabled?
    end
  end

  def call(&block)
    captured_content = block ? capture(&block) : content
    content_tag root_tag_name, captured_content, html_attributes
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
end
