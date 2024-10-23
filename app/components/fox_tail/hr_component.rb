# frozen_string_literal: true

class FoxTail::HrComponent < FoxTail::BaseComponent
  has_option :size, default: :base
  has_option :shape, default: :none
  has_option :trimmed, default: false, type: :boolean

  def shape?
    shape != :none
  end

  def call
    content_tag :div, class: wrapper_classes do
      if content? && shape == :none
        concat tag.hr(class: hr_classes)
        concat content_tag(:div, content, class: content_classes)
        concat tag.hr(class: hr_classes)
      else
        tag.hr(class: hr_classes)
      end
    end
  end

  private

  def wrapper_classes
    classnames theme.apply(:wrapper, self), html_class
  end

  def hr_classes
    theme.apply :root, self
  end

  def content_classes
    theme.apply :content, self
  end
end
