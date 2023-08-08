# frozen_string_literal: true

class Flowbite::HrComponent < Flowbite::BaseComponent

  has_option :size, default: :base
  has_option :shape, default: :none
  has_option :trimmed, default: false, type: :boolean

  def call
    content_tag :div, class: wrapper_classes do
      if content? && shape == :none
        concat content_tag(:hr, nil, class: hr_classes)
        concat content_tag(:div, content, class: content_classes)
        concat content_tag(:hr, nil, class: hr_classes)
      else
        content_tag :hr, nil, class: hr_classes
      end
    end
  end

  private

  def wrapper_classes
    classnames theme.classname("wrapper.base"),
               trimmed? && shape == :none && theme.classname("wrapper.trimmed"),
               html_class
  end

  def hr_classes
    classnames theme.classname("root.base"),
               shape == :none && theme.classname([:root, :size, size]),
               shape != :none && theme.classname(["root.shape.base"]),
               shape != :none && theme.classname([:root, :shape, shape]),
               shape != :none && theme.classname([:root, :shape, :size, size])
  end

  def content_classes
    classnames theme.classname("content.base")
  end
end
