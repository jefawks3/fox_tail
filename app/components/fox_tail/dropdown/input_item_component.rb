# frozen_string_literal: true

class FoxTail::Dropdown::InputItemComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Formable

  has_option :id
  has_option :name
  has_option :value

  def id
    options[:id] ||= tag_id
  end

  def name
    options[:name] ||= tag_name
  end

  def value
    options[:value] ||= value_from_object
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, html_attributes do
      concat content_tag(:div, input_content, class: input_container_classes)
      concat content_tag(:div, label_content, class: label_container_classes)
    end
  end

  def input_container_classes
    theme.apply :input_container, self
  end

  def label_container_classes
    theme.apply :label_container, self
  end

  def input_classes
    theme.apply :input, self
  end

  def label_classes
    theme.apply :label, self
  end

  def input_content
    raise NotImplementedError
  end

  def label_content
    label_tag id, content, class: label_classes
  end
end
