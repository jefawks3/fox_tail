# frozen_string_literal: true

class FoxTail::InputComponent < FoxTail::InputBaseComponent
  has_option :in, as: :range
  has_option :within, as: :within_range

  renders_one :left_visual, types: {
    icon: {
      as: :left_icon,
      renders: lambda { |icon, attributes = {}| render_icon :left, icon, attributes }
    },
    svg: {
      as: :left_svg,
      renders: lambda { |icon, attributes = {}| render_svg :left, icon, attributes }
    },
    image: {
      as: :left_image,
      renders: lambda { |icon, attributes = {}| render_image :left, icon, attributes }
    }
  }

  renders_one :right_visual, types: {
    icon: {
      as: :right_icon,
      renders: lambda { |icon, attributes = {}| render_icon :right, icon, attributes }
    },
    svg: {
      as: :right_svg,
      renders: lambda { |icon, attributes = {}| render_svg :right, icon, attributes }
    },
    spinner: {
      as: :right_spinner,
      renders: lambda { |attributes = {}| render_spinner :right, attributes }
    },
    image: {
      as: :right_image,
      renders: lambda { |icon, attributes = {}| render_image :right, icon, attributes }
    }
  }

  def visual?
    left_visual? || right_visual?
  end

  def before_render
    super

    html_attributes[:type] ||= :text
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    html_attributes[:value] ||= value_before_type_cast

    if html_attributes[:type] == :number
      format_range!
    elsif html_attributes[:type] == :submit
      format_submit!
    end
  end

  def call
    if visual?
      content_tag :div, class: theme.apply(:container, self) do
        concat render_visual :left, left_visual if left_visual?
        concat input_content
        concat render_visual :right, right_visual if right_visual?
      end
    else
      input_content
    end
  end

  private

  def format_range!
    range = self.range || within_range
    html_attributes.update("min" => range.min, "max" => range.max) if range
  end

  def format_submit!
    html_attributes[:data] ||= {}

    if html_attributes["data-disable-with"] == false || html_attributes[:data][:disabled_with] == false
      html_attributes[:data].delete :disabled_with
    elsif ActionView::Base.automatically_disable_submit_tag
      disabled_with = html_attributes["data-disabled-with"]
      disabled_with ||= html_attributes[:data][:disabled_with]
      disabled_with ||= html_attributes[:value].to_s.clone
      html_attributes[:data][:disabled_with] = disabled_with
    end
  end

  def input_content
    tag.input(**sanitized_html_attributes)
  end

  def visual_classes(position, classes)
    classnames theme.apply(:visual, self, {position: position}), classes
  end

  def render_icon(position, icon, attributes)
    attributes[:class] = visual_classes position, attributes[:class]
    FoxTail::IconBaseComponent.new icon, attributes
  end

  def render_svg(position, path, attributes)
    attributes[:class] = visual_classes position, attributes[:class]
    FoxTail::InlineSvgComponent.new path, attributes
  end

  def render_spinner(position, attributes)
    attributes[:class] = visual_classes position, attributes[:class]
    FoxTail::SpinnerComponent.new attributes
  end

  def render_image(position, path, attributes)
    attributes[:class] = visual_classes position, attributes[:class]
    image_tag path, attributes
  end

  def render_visual(position, visual)
    content_tag :div, visual, class: theme.apply(:"visual/container", self, {position: position})
  end
end
