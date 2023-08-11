# frozen_string_literal: true

class Flowbite::AvatarComponent < Flowbite::BaseComponent
  renders_one :dot, lambda { |options = {}|
    dot_options = options.extract!(:position).reverse_merge(position: :top_right)
    options[:class] = classnames theme.apply(:dot, dot_options), options[:class]
    Flowbite::DotIndicatorComponent.new(**options)
  }

  has_option :src
  has_option :icon
  has_option :text
  has_option :size, default: :base
  has_option :rounded, type: :boolean, default: false

  has_option :border, default: false do |_border, value|
    if value.is_a?(TrueClass)
      :default
    elsif !value
      :none
    else
      value.to_sym
    end
  end

  def border?
    border != :none
  end

  def call
    if dot?
      content_tag :div, class: theme.apply("dot/container", self) do
        concat dot
        concat render_visual
      end
    else
      render_visual
    end
  end

  private

  def root_classes
    classnames theme.apply(:root, self), html_class
  end

  def render_visual
    if src?
      render_image
    elsif icon?
      render_icon
    elsif text?
      render_text
    else
      render_blank
    end
  end

  def render_image
    image_tag src, html_attributes.merge(class: root_classes)
  end

  def render_icon
    icon_classes = theme.apply :icon, self
    label = html_attributes[:alt]
    icon_name, icon_variant = if icon.is_a? Hash
                                [icon[:name], icon[:variant]]
                              else
                                [icon, :solid]
                              end

    content_tag :div, html_attributes.except(:alt).merge(class: root_classes) do
      concat render(Flowbite::IconBaseComponent.new(icon_name, variant: icon_variant, class: icon_classes))
      concat content_tag(:span, label, class: label_classes) if label.present?
    end
  end

  def render_text
    label = html_attributes[:alt]
    text_classes = theme.apply :text, self

    content_tag :div, html_attributes.except(:alt).merge(class: root_classes) do
      concat content_tag(:span, text, class: text_classes)
      concat content_tag(:span, label, class: label_classes) if label.present?
    end
  end

  def render_blank
    label = html_attributes[:alt]

    content_tag :div, html_attributes.except(:alt).merge(class: root_classes) do
      content_tag(:span, label, class: label_classes) if label.present?
    end
  end
end
