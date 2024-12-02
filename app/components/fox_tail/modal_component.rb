# frozen_string_literal: true

class FoxTail::ModalComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable

  renders_one :trigger, lambda { |options = {}|
    FoxTail::ModalTriggerComponent.new "##{id}", options
  }

  has_option :placement, default: :center
  has_option :backdrop, type: :boolean, default: true
  has_option :static, type: :boolean, default: false
  has_option :size, default: :base
  has_option :closeable, type: :boolean, default: true
  has_option :open, type: :boolean, default: false

  stimulated_with [:fox_tail, :modal], as: :modal do |controller|
    controller.with_value :static, static?
    controller.with_value :closeable, closeable?
    controller.with_value :open, open?
    controller.with_class :visible, visible_classes
    controller.with_class :hidden, hidden_classes
  end

  def close_action(event: :click)
    modal_controller.action :hide, on: event
  end

  def merge_close_action(attributes, event: :click)
    attributes[:data] ||= {}
    attributes[:data][:action] = stimulus_merger.merge_actions attributes[:data][:action], close_action(event: event)
    attributes
  end

  def before_render
    super

    generate_unique_id
    html_attributes[:class] = root_classes
    html_attributes[:tabindex] = -1
    html_attributes[:aria] ||= {}
    html_attributes[:aria][:hidden] = true
  end

  def call
    capture do
      concat trigger if trigger?
      concat render_modal
    end
  end

  def close_icon_button_component(icon_or_options = {}, options = {})
    if icon_or_options.is_a? Hash
      options = icon_or_options
      icon_or_options = "x-mark"
    end

    options = merge_close_action options
    options[:variant] = :modal
    options[:color] = :modal
    options[:size] = :modal
    options[:theme] = theme.theme :close_icon_button

    component = FoxTail::IconButtonComponent.new options
    component.with_icon icon_or_options if icon_or_options.present?
    component
  end

  def close_button_component(options = {})
    options = merge_close_action options
    FoxTail::ButtonComponent.new options
  end

  protected

  def root_classes
    classnames theme.apply(:root, self), hidden_classes, html_class
  end

  def visible_classes
    theme.apply "root/visible", self
  end

  def hidden_classes
    theme.apply "root/hidden", self
  end

  private

  def content_attributes
    attributes = {class: theme.apply(:content, self)}
    attributes[:data] = {modal_controller.target_attribute_name => :content}
    attributes
  end

  def render_backdrop
    content_tag :div, nil, class: theme.apply(:backdrop, self)
  end

  def render_modal
    content_tag :div, html_attributes do
      concat render_backdrop if backdrop?
      concat content_tag(:div, content, content_attributes)
    end
  end
end
