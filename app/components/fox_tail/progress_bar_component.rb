# frozen_string_literal: true

class FoxTail::ProgressBarComponent < FoxTail::BaseComponent
  attr_reader :value

  has_option :size, default: :base
  has_option :color, default: :default
  has_option :show_label, type: :boolean, default: false
  has_option :controlled, type: :boolean, default: false

  stimulated_with [:fox_tail, :progress_bar], as: :progress_bar, if: :controlled? do |controller|
    controller.with_value :progress, value
    controller.with_value :show_label, show_label?
  end

  def initialize(value, html_attributes = {})
    super(html_attributes)
    @value = value
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    html_attributes[:aria] ||= {}
    html_attributes[:aria][:valuenow] = value
    html_attributes[:aria][:valuemin] = 0
    html_attributes[:aria][:valuemax] = 100
  end

  def call
    content_tag :div, html_attributes do
      content_tag :div, label, bar_attributes
    end
  end

  private

  def label
    return unless show_label?
    return content if content?

    "#{value.round}%"
  end

  def bar_attributes
    attributes = {class: theme.apply(:bar, self), style: "width: #{value}%"}
    attributes[:data] = {progress_bar_controller.target_attribute_name => :bar} if controlled?
    attributes
  end
end
