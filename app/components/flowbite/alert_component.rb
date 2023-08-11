# frozen_string_literal: true

class Flowbite::AlertComponent < Flowbite::DismissibleComponent
  SEVERITY_ICONS = { success: "check-circle", warning: "exclamation-triangle", error: "exclamation-circle" }.freeze
  DEFAULT_SEVERITY_ICON = "information-circle"

  attr_reader :id

  renders_one :header, lambda { |options = {}, &block|
    options[:class] = classnames theme.apply(:header, self), options[:class]
    content_tag(:h3, options, &block)
  }

  renders_one :icon, lambda { |options = {}|
    name = options.delete(:icon) || severity_icon_name
    options[:class] = classnames theme.apply(:icon, self), options[:class]
    options[:variant] ||= :mini
    Flowbite::IconBaseComponent.new name, options
  }

  renders_one :dismiss_icon, lambda { |options = {}, &block|
    content = block ? capture(&block) : I18n.t("components.flowbite.close")
    icon_options = options.slice(:icon, :variant).reverse_merge(icon: "x-mark", variant: :solid)
    icon_options[:class] = theme.apply "dismiss.icon", self
    dismiss_actions! options
    options[:class] = classnames theme.apply("dismiss.button", self), options[:class]

    content_tag :button, options do
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
        dismiss_actions! options
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
      value.to_sym
    end
  end

  def border?
    border != :none
  end

  private

  def root_classes
    classnames theme.apply(:root, self), html_class
  end

  def severity_icon_name
    SEVERITY_ICONS.fetch severity.to_sym, DEFAULT_SEVERITY_ICON
  end

  def dismiss_actions!(attributes)
    return unless use_stimulus?

    attributes[:data] ||= {}
    attributes[:data][:action] = stimulus_merger.merge_actions attributes[:data][:action],
                                                               stimulus_controller.action("dismiss")
  end
end
