# frozen_string_literal: true

class FoxTail::BadgeComponent < FoxTail::BaseComponent
  renders_one :icon, lambda { |icon, options = {}|
    options[:"aria-hidden"] = true
    options[:class] = classnames theme.apply(:icon, self), options[:class]
    FoxTail::IconBaseComponent.new icon, options
  }

  renders_one :dismiss_icon, lambda { |options = {}|
    icon_options = options.extract!(:icon, :variant).reverse_merge(icon: "x-mark", variant: :solid)
    icon_options[:class] = classnames theme.apply(:icon, self), theme.apply(:dismiss_icon, self)
    options[:class] = classnames theme.apply(:dismiss_button, self), options[:class]

    FoxTail::WrapperComponent.new options do |wrapper|
      content = wrapper.content? ? wrapper.content : I18n.t("components.fox_tail.close")

      render FoxTail::ClickableComponent.new(wrapper.html_attributes) do
        concat render(FoxTail::IconBaseComponent.new(icon_options[:icon], icon_options.except(:icon)))
        concat content_tag(:div, content, class: theme.classname("accessibility.sr_only"))
      end
    end
  }

  has_option :url
  has_option :size, default: :base
  has_option :color, default: :default
  has_option :pill, default: false, type: :boolean
  has_option :icon_only, default: false, type: :boolean
  has_option :border, default: false, type: :boolean

  def tag_name
    url? ? :a : :span
  end

  def before_render
    super

    html_attributes[:href] = url if url?
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag tag_name, html_attributes do
      concat icon if icon?
      concat content_tag(:span, content, class: theme.apply(:content, self)) if content?
      concat dismiss_icon if dismiss_icon?
    end
  end
end
