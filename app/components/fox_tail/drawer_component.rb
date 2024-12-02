# frozen_string_literal: true

class FoxTail::DrawerComponent < FoxTail::BaseComponent
  renders_one :close_button, types: {
    icon: {
      as: :close_icon,
      renders: lambda { |icon_or_options = {}, options = {}, icon_options = {}|
        if icon_or_options.is_a? Hash
          icon_options = options
          options = icon_or_options
          icon_or_options = "x-mark"
        end

        options = FoxTail::HtmlAttributes.new options

        options[:class] = classnames theme.apply("close/button", self), options[:class]
        icon_options[:class] = classnames theme.apply("close/icon", self), icon_options[:class]

        options.merge_stimulus_actions! drawer_controller.action(:hide)

        content_tag :button, options do
          concat render(FoxTail::IconBaseComponent.new(icon_or_options, icon_options))
          concat content_tag(:span, I18n.t("fox_tail.close"), class: theme.classname("accessibility.sr_only"))
        end
      }
    }
  }

  renders_one :notch, lambda { |options = {}|
    options[:class] = classnames theme.apply(:notch, self), options[:class]
    content_tag :span, nil, options
  }

  has_option :placement, default: :left
  has_option :body_scrolling, type: :boolean, default: false
  has_option :backdrop, type: :boolean, default: true
  has_option :swipeable_edge, default: false
  has_option :open, type: :boolean, default: false
  has_option :border, type: :boolean, default: false
  has_option :rounded, type: :boolean, default: false
  has_option :tag_name, default: :div

  stimulated_with [:fox_tail, :drawer], as: :drawer do |controller|
    controller.with_value :backdrop, backdrop?
    controller.with_value :body_scrolling, body_scrolling?
    controller.with_value :open, open?
    controller.with_class :visible, visible_classes
    controller.with_class :hidden, hidden_classes
    controller.with_class :backdrop, backdrop_classes
    controller.with_class :body, body_classes
  end

  def before_render
    super

    html_attributes[:class] = classnames(
      theme.apply(:root, self),
      open? ? visible_classes : hidden_classes,
      html_class
    )

    html_attributes[:tab_index] ||= -1
    html_attributes[:aria] ||= {}
    html_attributes[:aria][:hidden] = open?
  end

  def call
    content_tag tag_name, html_attributes do
      concat close_button if close_button?
      concat notch if notch?
      yield if block_given?
      concat content
    end
  end

  private

  def visible_classes
    theme.apply "root/visible", self
  end

  def hidden_classes
    classnames theme.apply("root/hidden", self), swipeable_edge_classes
  end

  def swipeable_edge_classes
    return unless swipeable_edge?
    return swipeable_edge if swipeable_edge.is_a? String

    theme.apply :swipeable_edge, self
  end

  def backdrop_classes
    theme.apply :backdrop, self
  end

  def body_classes
    theme.apply :body, self
  end
end
