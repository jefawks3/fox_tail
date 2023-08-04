# frozen_string_literal: true

class Flowbite::AlertComponent < Flowbite::BaseComponent
  SEVERITY_ICONS = { success: "check-circle", warning: "exclamation-triangle", error: "exclamation-circle" }.freeze
  DEFAULT_SEVERITY_ICON = "information-circle"

  attr_reader :id

  renders_one :header, lambda { |options = {}, &block|
    options[:class] = classnames theme.classname("header.base"), options[:class]
    content_tag(:h3, options, &block)
  }

  renders_one :icon, lambda { |options = {}|
    name = options.delete(:icon) || severity_icon_name
    options[:class] = classnames theme.classname("icon.base"), options[:class]
    options[:variant] ||= :mini
    Flowbite::IconBaseComponent.new name, options
  }

  renders_one :dismiss_icon, lambda { |options = {}, &block|
    content = block ? capture(&block) : I18n.t("flowbite.close")
    icon_options = options.slice(:icon, :variant).reverse_merge(icon: "x-mark", variant: :solid)
    icon_options[:class] = theme.classname "dismiss.icon"
    options[:class] = classnames theme.classname("dismiss.base"),
                                 theme.classname([:dismiss, :severity, severity]),
                                 options[:class]

    render(Flowbite::DismissComponent.new(id, options)) do
      concat render(Flowbite::IconBaseComponent.new(icon_options[:icon], icon_options.except(:icon)))
      concat content_tag(:div, content, class: theme.classname("accessibility.sr_only"))
    end
  }

  renders_many :buttons, types: {
    button: {
      renders: lambda { |options = {}|
        options[:variant] ||= :solid
        options[:color] ||= severity
        options[:size] ||= :xs
        Flowbite::ButtonComponent.new options
      },
      as: :button
    },
    dismiss: {
      renders: lambda { |options = {}|
        options[:variant] ||= :outline
        options[:color] ||= severity
        options[:size] ||= :xs
        dismiss_options = options.extract!(*Flowbite::DismissComponent.dismiss_options_keys)
        dismiss_options[:target_id] = id
        Flowbite::DismissComponent.controller.merge! options, dismiss_options
        Flowbite::ButtonComponent.new options
      },
      as: :dismiss_button
    }
  }

  has_option :severity, default: :info
  has_option :rounded, default: true, type: :boolean
  has_option :border, default: :none do |_border, value|
    if value.is_a?(TrueClass)
      :basic
    elsif !value
      :none
    else
      value
    end
  end

  def initialize(id, html_attributes = {})
    @id = id
    super(html_attributes)
  end

  private

  def root_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :severity, severity]),
               rounded? && theme.classname("root.rounded"),
               border != :none && theme.classname("root.border.base"),
               border != :none && theme.classname([:root, :border, border]),
               border != :none && theme.classname([:root, :border, :severity, severity]),
               html_class
  end

  def severity_icon_name
    SEVERITY_ICONS.fetch severity.to_sym, DEFAULT_SEVERITY_ICON
  end
end
