# frozen_string_literal: true

class FoxTail::DismissibleComponent < FoxTail::BaseComponent
  has_option :remove, default: false, type: :boolean
  has_option :auto_close, default: false, type: :boolean
  has_option :delay, default: 3000
  has_option :dismissible, default: true, type: :boolean

  stimulated_with [:fox_tail, :dismissible], as: :dismissible, if: :dismissible? do |controller|
    controller.with_value :remove, remove?
    controller.with_value :auto_close, auto_close?
    controller.with_value :delay, delay
    controller.with_class :dismissing, theme.apply("root/dismissing", self)
    controller.with_class :dismissed, theme.apply("root/dismissed", self)
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag(:div, content, html_attributes)
  end
end
