# frozen_string_literal: true

class FoxTail::AlertComponent < FoxTail::DismissibleComponent
  SEVERITY_ICONS = {success: "check-circle", warning: "exclamation-triangle", danger: "exclamation-circle"}.freeze
  DEFAULT_SEVERITY_ICON = "information-circle"

  renders_one :header, lambda { |text_or_options = {}, options = {}, &block|
    if block
      options = text_or_options
      text_or_options = nil
    end

    text_or_options ||= capture(&block)
    options[:class] = classnames theme.apply(:header, self), options[:class]
    content_tag :h3, text_or_options, options
  }

  renders_one :icon, lambda { |options = {}|
    name = options.delete(:icon) || severity_icon_name
    options[:icon_set] ||= :hero
    options[:class] = classnames theme.apply(:icon, self), options[:class]
    FoxTail::IconBaseComponent.new name, options
  }

  renders_one :dismiss_icon, lambda { |options = {}, &block|
    options = FoxTail::HtmlAttributes.new options
    content = block ? capture(&block) : I18n.t("components.fox_tail.close")
    icon_options = options.slice(:icon, :variant, :icon_set).reverse_merge(icon: "x-mark", variant: :solid)
    icon_options[:class] = theme.apply "dismiss.icon", self
    options[:class] = classnames theme.apply("dismiss.button", self), options[:class]
    options[:type] = :button
    options.merge_stimulus_actions! dismissible_controller.action(:dismiss) if dismissible?

    content_tag :button, options do
      concat render(FoxTail::IconBaseComponent.new(icon_options[:icon], icon_options.except(:icon)))
      concat content_tag(:div, content, class: theme.classname("accessibility.sr_only"))
    end
  }

  renders_many :buttons, types: {
    button: {
      renders: lambda { |options = {}|
        options[:variant] ||= :solid
        options[:color] ||= severity
        options[:size] ||= :xs
        FoxTail::ButtonComponent.new options
      },
      as: :button
    },
    dismiss: {
      renders: lambda { |options = {}|
        options = FoxTail::HtmlAttributes.new options
        options[:variant] ||= :outline
        options[:color] ||= severity
        options[:size] ||= :xs
        options.merge_stimulus_actions! dismissible_controller.action(:dismiss) if dismissible?
        FoxTail::ButtonComponent.new options
      },
      as: :dismiss_button
    }
  }

  has_option :severity, default: :info
  has_option :rounded, default: true, type: :boolean
  has_option :border, default: :none

  def border?
    border != :none
  end

  def border
    if options[:border].is_a?(TrueClass)
      :basic
    elsif !options[:border]
      :none
    else
      (options[:border] || :none).to_sym
    end
  end

  def before_render
    super

    with_dismiss_icon unless !dismissible? || dismiss_icon

    html_attributes[:class] = root_classes
    html_attributes[:role] = :alert
  end

  private

  def root_classes
    classnames theme.apply(:root, self), html_class
  end

  def severity_icon_name
    SEVERITY_ICONS.fetch severity.to_sym, DEFAULT_SEVERITY_ICON
  end
end
